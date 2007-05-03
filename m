Return-Path: <linux-kernel-owner+w=401wt.eu-S1161862AbXECMEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161862AbXECMEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161861AbXECMEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:04:12 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:41758 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161862AbXECMEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QXAzF9syjAtywsIwnDrWfvxAvxbXvzlIDKfK/Flt2DkF8oK/kg2tbcTmfH6Z2gbsKci21GOBHR2ncWbA+ebZv0xISR/3QLxLtp/s+2Erd1CdUUyWxzvOAIyMK8/Ml5h9BcB+ecoE2QbcupN72fwBjsIOSJLgGrnhgz7k9cO7p6g=
Subject: Re: dead CONFIG_ variables:   drivers/video/
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705030638270.380@localhost.localdomain>
References: <Pine.LNX.4.64.0705030638270.380@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 03 May 2007 20:04:04 +0800
Message-Id: <1178193844.4606.64.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 06:40 -0400, Robert P. J. Day wrote:
> $ ../dead_config.sh drivers/video
> ========== FB_68328_INVERT ==========
> drivers/video/68328fb.c:53:#if defined(CONFIG_FB_68328_INVERT)

Can be made part of Kconfig, I think

> ========== FB_AU1200_DEVS ==========
> drivers/video/au1200fb.c:52:#ifndef CONFIG_FB_AU1200_DEVS
> drivers/video/au1200fb.c:53:#define CONFIG_FB_AU1200_DEVS 4
> drivers/video/au1200fb.c:160:static struct au1200fb_device _au1200fb_devices[CONFIG_FB_AU1200_DEVS];
> drivers/video/au1200fb.c:714:   for (i = 0; i < CONFIG_FB_AU1200_DEVS; ++i) {
> drivers/video/au1200fb.c:1635:  for (plane = 0; plane < CONFIG_FB_AU1200_DEVS; ++plane) {
> drivers/video/au1200fb.c:1730:  for (plane = 0; plane < CONFIG_FB_AU1200_DEVS; ++plane)
> drivers/video/au1200fb.c:1850:                  for (plane = 0; plane < CONFIG_FB_AU1200_DEVS; ++plane)         {

Not sure about this one.

> ========== FB_MATROX_32MB ==========
> drivers/video/matrox/matroxfb_base.c:307:#ifdef CONFIG_FB_MATROX_32MB
> drivers/video/matrox/matroxfb_base.c:327:#ifdef CONFIG_FB_MATROX_32MB
> drivers/video/matrox/matroxfb_base.c:339:#ifdef CONFIG_FB_MATROX_32MB
> drivers/video/matrox/matroxfb_base.c:1342:#ifdef CONFIG_FB_MATROX_32MB
> drivers/video/matrox/matroxfb_base.c:1619:#ifdef CONFIG_FB_MATROX_32MB
> drivers/video/matrox/matroxfb_DAC1064.c:1053:#ifdef CONFIG_FB_MATROX_32MB
> drivers/video/matrox/matroxfb_base.h:58:#define CONFIG_FB_MATROX_32MB
> drivers/video/matrox/matroxfb_base.h:466:#ifdef CONFIG_FB_MATROX_32MB

This needs to be part of Kconfig.

> ========== FB_NVIDIA_DEBUG ==========
> drivers/video/nvidia/nvidia.c:40:#undef CONFIG_FB_NVIDIA_DEBUG
> drivers/video/nvidia/nvidia.c:41:#ifdef CONFIG_FB_NVIDIA_DEBUG
> drivers/video/nvidia/nvidia.c:50:#ifdef CONFIG_FB_NVIDIA_DEBUG

False positive, may be renamed.

> ========== FB_SOFT_CURSOR ==========
> drivers/video/sis/sis_main.c:1906:#ifdef CONFIG_FB_SOFT_CURSOR

This is dead, FB_SOFT_CURSOR is truly gone.

Thanks.

Tony

