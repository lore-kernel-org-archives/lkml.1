Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZCEXnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZCEXnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZCEXm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:42:57 -0500
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:49279 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbZCEXm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:42:56 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-11.arcor-online.net 9E833E3DEB
From: Prakash Punnoor <prakash@punnoor.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
Date: Fri, 6 Mar 2009 00:45:12 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7; KDE/4.2.1; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903040815.38387.prakash@punnoor.de> <20090305171514.GB1021@parisc-linux.org>
In-Reply-To: <20090305171514.GB1021@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903060045.13509.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag 05 März 2009 18:15:14 Matthew Wilcox wrote:
> On Wed, Mar 04, 2009 at 08:15:37AM +0100, Prakash Punnoor wrote:
> > 2.6.29-rc7 is released, but the last two patches here in the thread have
> > not been picked up. Why?
>
> Oh, I meant to say ... we're at -rc7.  What is the danger here of this
> fixing your machine but breaking somebody else's?

There is a danger that less host bridges get HT MSI enabled by the quirk -
which might need it after all.

> Is there something we
> can minimally do that fixes your machine today and then put in a patch
> for 30-rc1 that is likely to fix other machines?

Something like this would be minimal and works for me:

--- drivers/pci/quirks.c.old    2009-03-06 00:34:40.996532222 +0100
+++ drivers/pci/quirks.c        2009-03-06 00:37:06.915532269 +0100
@@ -2141,6 +2141,10 @@
        int pos;
        int found;

+       /* Enabling HT MSI mapping on this device breaks MCP51 */
+       if (dev->device == 0x270)
+               return;
+
        /* check if there is HT MSI cap or enabled on this device */
        found = ht_check_msi_mapping(dev);


