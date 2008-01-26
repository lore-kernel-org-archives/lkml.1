Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbYAZKU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbYAZKU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 05:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYAZKUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 05:20:49 -0500
Received: from qb-out-0506.google.com ([72.14.204.235]:58763 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbYAZKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 05:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jAyhIJl+7tr+ZQMMaHNU4+NetXiSLn2Lm1w2fmCtl8vDey+S6ph3thnAPNR6vRs02pCiIpAXhyYwlVQ2gs+gxTVyHiDUQsvOgl56aZVs5nukHJJwgOFenElnC6KAQk11GuzYLZ4n0+cz6/70NOdt6I74BY7xivtai+wczMFXcAE=
Date: Sat, 26 Jan 2008 18:18:36 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Shut up warnings from files under drivers/
Message-ID: <20080126101835.GD20935@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479B03AE.3090600@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 04:55:58AM -0500, Jeff Garzik wrote:
>WANG Cong wrote:
>>diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
>>index acb9370..437ebd0 100644
>>--- a/drivers/video/kyro/fbdev.c
>>+++ b/drivers/video/kyro/fbdev.c
>>@@ -90,7 +90,9 @@ static int nomtrr __devinitdata = 0;
>> 
>> /* PCI driver prototypes */
>> static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id 
>> *ent);
>>+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
>> static void kyrofb_remove(struct pci_dev *pdev);
>>+#endif
>> 
>> static struct fb_videomode kyro_modedb[] __devinitdata = {
>> 	{
>>@@ -754,6 +756,7 @@ out_unmap:
>> 	return -EINVAL;
>> }
>> 
>>+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
>> static void __devexit kyrofb_remove(struct pci_dev *pdev)
>> {
>> 	struct fb_info *info = pci_get_drvdata(pdev);
>>@@ -783,6 +786,7 @@ static void __devexit kyrofb_remove(struct pci_dev 
>>*pdev)
>> 	pci_set_drvdata(pdev, NULL);
>> 	framebuffer_release(info);
>> }
>>+#endif
>
>
>Quite strange -- due to __devexit_p() and the __devexit marker, ifdefs 
>should not be needed.
>
>I would look into why that isn't working as designed in these cases...
>

For example, the defination of __devexit_p:

#if defined(MODULE) || defined(CONFIG_HOTPLUG)
#define __devexit_p(x) x
#else
#define __devexit_p(x) NULL
#endif

If !(defined(MODULE) || defined(CONFIG_HOTPLUG)), __devexit_p
is just a NULL pointer, thus 'x' may be unused although defined.

