Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbZG3Nv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbZG3Nv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZG3Nv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:51:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55591 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbZG3Nv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:51:26 -0400
Subject: Re: linux-next: scsi-rc-fixes tree build failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tom Peng <tom_peng@usish.com>, Jack Wang <jack_wang@usish.com>,
       Lindar Liu <lindar_liu@usish.com>, Kevin Ao <aoqingyun@usish.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20090730181345.cec774b2.sfr@canb.auug.org.au>
References: <20090730181345.cec774b2.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 08:51:22 -0500
Message-Id: <1248961882.3880.4.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 18:13 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/scsi/libsas/sas_expander.c: In function 'sas_find_bcast_dev':
> drivers/scsi/libsas/sas_expander.c:1701: error: 'FALSE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c: In function 'sas_discover_new':
> drivers/scsi/libsas/sas_expander.c:1809: error: 'FALSE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c:1824: error: 'TRUE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c: In function 'sas_rediscover':
> drivers/scsi/libsas/sas_expander.c:1903: error: 'TRUE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c:1918: error: 'FALSE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c: In function 'sas_ex_revalidate_domain':
> drivers/scsi/libsas/sas_expander.c:1951: error: 'TRUE' undeclared (first use in this function)
> 
> Caused by commit 4c70d933a41e1d712f3db90d2a41141730383d5a ("[SCSI]
> libsas: fix wide port hotplug issues").  Presumably a missing include
> file.

Actually, I don't think so.  It's confusion over the use of boolean
variables.  I think they have to be set to lower case true, false, not
upper case.  There's obviously some accidental definition of TRUE and
FALSE in x86.

> I have reverted that commit for today.

Thanks, I've dropped it from my tree ... I'll put it back when this is
sorted out.

James


