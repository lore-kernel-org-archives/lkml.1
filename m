Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbZK0VkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbZK0VkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 16:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZK0VkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 16:40:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:48979 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751662AbZK0Vj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 16:39:59 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+ypuc5WGyy8hqEPUDun/Gp+gQ/h9oj8PBm/CYz1Z
	2o+dqR7Een/F0J
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL for 2.6.32] V4L/DVB updates
Date: Fri, 27 Nov 2009 22:40:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc8-sidux-amd64; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <4B103CE1.8050303@redhat.com>
In-Reply-To: <4B103CE1.8050303@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911272240.02930.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 27 November 2009, Mauro Carvalho Chehab wrote:
> Hi Linus,
> 
> Please pull from:
>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus
> 
> For the following drivers and building fixes:
> 
>    - radio-gemtek-pci: fix double mutex_lock
>    - v4l: add more missing linux/sched.h includes
>    - soc-camera: properly initialise the device object when reusing
>    - soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable
>    - em28xx: fix Reddo DVB-C USB TV Box GPIO
>    - davinci: remove stray duplicate config pointer
>    - SMS_SIANO_MDTV should depend on HAS_DMA
>    - cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
>    - sh_mobile_ceu_camera: fix compile warning
>    - Fix wrong parameter order in memset
[...]

Please consider cherry picking the following two patches from Hans 
Verkuil [1]:
- add the missing s2250-loader.h
- s2250 mutex patch	

or revert the patch which broke compiling go7007-usb (imho it would be 
better to re-add the 2 externs [2], than throwing away the needed mutex 
conversion, but it would be an option)
Commit:	fd9a40da1db372833e1af6397d2f6c94ceff3dad
		V4L/DVB (12859): go7007: semaphore -> mutex conversion

or mark CONFIG_VIDEO_GO7007_USB_S2250_BOARD as BROKEN, as it fails to 
compile since the afforementioned patch was merged on september 19th (this 
is a 2.6.31 --> 2.6.32 regression) [2,3].

Regards
	Stefan Lippers-Hollmann

[1]	http://www.mail-archive.com/linux-media@vger.kernel.org/msg11736.html
[2]	http://lkml.indiana.edu/hypermail/linux/kernel/0911.1/02303.html
[3]	http://lkml.indiana.edu/hypermail/linux/kernel/0909.3/00062.html
