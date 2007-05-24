Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbXEXRBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbXEXRBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXEXRBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:01:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33099 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751917AbXEXRBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:01:42 -0400
Date: Thu, 24 May 2007 10:01:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
In-Reply-To: <46559B54.80106@googlemail.com>
Message-ID: <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Michal Piotrowski wrote:

> Memory management
> 
> Subject    : kernel BUG at include/linux/slub_def.h:88 kmalloc_index()
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8476
> Submitter  : Cherwin R. Nooitmeer <cherwin@gmail.com>
> Status     : Unknown


Looks like this is in DRM code:

BUG: at include/linux/slub_def.h:88 kmalloc_index()
 [<c014f67f>] get_slab+0x43/0x1c6
 [<c014f875>] __kmalloc+0xc/0x57
 [<f0a7b564>] drm_rmdraw+0x0/0x27d [drm]
 [<f0a7b698>] drm_rmdraw+0x134/0x27d [drm]
 [<f0a7b564>] drm_rmdraw+0x0/0x27d [drm]
 [<f0a7c1d0>] drm_ioctl+0x144/0x18c [drm]
 [<c01265ad>] enqueue_hrtimer+0xe3/0xef
 [<c015c184>] do_ioctl+0x4c/0x64
 [<c015c3c7>] vfs_ioctl+0x22b/0x23e
 [<c015c40d>] sys_ioctl+0x33/0x4e
 [<c0103ca0>] syscall_call+0x7/0xb

