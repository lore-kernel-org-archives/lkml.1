Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYC1RtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYC1RtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYC1Rs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:48:56 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:5909 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754454AbYC1Rsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:48:55 -0400
Date: Fri, 28 Mar 2008 20:48:53 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Scott Wood <scottwood@freescale.com>
Cc: York Sun <yorksun@freescale.com>, linux-fbdev-devel@lists.sourceforge.net,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 1/2 v4] Driver for Freescale 8610 and 5121 DIU
Message-ID: <20080328174853.GA1438@localhost.localdomain>
Reply-To: avorontsov@ru.mvista.com
References: <12066720572512-git-send-email-yorksun@freescale.com> <12066720572314-git-send-email-yorksun@freescale.com> <47ED2B35.4030601@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <47ED2B35.4030601@freescale.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 12:30:29PM -0500, Scott Wood wrote:
> York Sun wrote:
> >+static int fsl_diu_ioctl(struct fb_info *info, unsigned int cmd,
> >+		       unsigned long arg)
> >+{
> >+	struct mfb_info *mfbi = info->par;
> >+	struct diu_ad *ad = mfbi->ad;
> >+	struct mfb_chroma_key ck;
> >+	unsigned char global_alpha;
> >+	struct aoi_display_offset aoi_d;
> >+	__u32 pix_fmt;
> >+
> >+	switch (cmd) {
> >+	case MFB_SET_PIXFMT:
> >+		if (!arg)
> >+			return -EINVAL;
> >+		if (copy_from_user(&pix_fmt, (void __user *)arg,
> >+				sizeof(pix_fmt)))
> 
> OK, you fixed the cast here...

Maybe better would be to define "buf" at the top of this function as
void __user *buf = (void __user *)arg;, i.e. just once?

> 
> >+			return -EFAULT;
> >+		ad->pix_fmt = pix_fmt;
> >+		pr_debug("Set pixel format to 0x%08x\n", ad->pix_fmt);
> >+		break;
> >+	case MFB_GET_PIXFMT:
> >+		if (!arg)
> >+			return -EINVAL;

This if (!arg) appears to be everywhere except default: label, maybe
this could be placed on top too?

> >+		pix_fmt = ad->pix_fmt;
> >+		if (copy_to_user((void *)arg, &pix_fmt, sizeof(pix_fmt)))
> >+			return -EFAULT;
> >+		pr_debug("get pixel format 0x%08x\n", ad->pix_fmt);
> >+		break;
> >+	case MFB_SET_AOID:
> >+		if (!arg)
> >+			return -EINVAL;
> >+		if (copy_from_user(&aoi_d, (void *)arg, sizeof(aoi_d)))
> >+			return -EFAULT;
> 
> ...but not anywhere else.  All user pointers should have a __user 
> annotation.

-- 
Anton Vorontsov
email: cboumailru@gmail.com
irc://irc.freenode.net/bd2
