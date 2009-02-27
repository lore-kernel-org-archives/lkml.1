Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbZB0Guk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbZB0Guk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbZB0Gub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:50:31 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:49341 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540AbZB0Gua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:50:30 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-04.arcor-online.net 4929333A74B
From: Prakash Punnoor <prakash@punnoor.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
Date: Fri, 27 Feb 2009 07:52:43 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6; KDE/4.2.0; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <49A2FE5F.2080307@kernel.org> <200902240937.36362.jbarnes@virtuousgeek.org>
In-Reply-To: <200902240937.36362.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902270752.44078.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag 24 Februar 2009 18:37:35 Jesse Barnes wrote:
> On Monday, February 23, 2009 11:51:59 am Yinghai Lu wrote:
> > Impact: fix bug
> >
> > Prakash reported that his c51-mcp51 system ondie sound card doesn't work
> > MSI but if he hack out the HT-MSI on mcp51, the MSI will work well with
> > sound card.
> >
> > this patch rework the nv_msi_ht_cap_quirk()
> > and will only enable ht_msi on own root device and try to avoid to enable
> > ht_msi on device following that root dev
> >
> > Reported-by: Prakash Punnoor <prakash@punnoor.de>
> > Tested-by: Prakash Punnoor <prakash@punnoor.de>
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Thanks Yinghai & Prakash, applied this fix to my for-linus branch.

I am very sorry, but I made a mistake testing this patch. I messed up my 
kernels and got a false positive and only noticed this now. The patch does NOT 
work and even makes things worse:

dmesg|grep HT
pci 0000:00:09.0: Found disabled HT MSI Mapping
pci 0000:00:09.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Found enabled HT MSI Mapping
pci 0000:00:09.0: Found enabled HT MSI Mapping
pci 0000:00:09.0: Found enabled HT MSI Mapping
pci 0000:00:09.0: Found enabled HT MSI Mapping

This is exactly the device which shouldn't be MSI enabled for me. On the other 
hand, it doesn't enable the needed devices anymore.

So please drop this patch.

Regards,

Prakash
