Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZD2KDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZD2KDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZD2KDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:03:44 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37151 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZD2KDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:subject:date:mime-version:content-type
         :content-transfer-encoding:x-priority:x-msmail-priority:x-mailer
         :x-mimeole;
        b=NoJgfpwNghnq/SLu2JgAGkGDpa786RlxedI/yl5cjaaGc7jLNCdB68vgc2mfsT7mj5
         9gGVdZivsM3LwmfkHJcZfoZyJMkNFbDeh4pb45BhBaKwNgRVP7MlrItMjpsnG6W2f1fv
         0ZjvYhwg2d9is0ObJDnZIsMb6zTGGFcxpSyr0=
Message-ID: <7D4BD025A2554467AD77428C455E1FE0@avitech.sk>
From: "Peter Hanzel" <hanzelpeter@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       <dri-devel@lists.sourceforge.net>
Subject: Intel KMS + fbcon + Mplayer
Date: Wed, 29 Apr 2009 12:04:07 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I have tried Intel KMS in kernel 2.6.91.1 with fbcon. I am using only 
framebuffer console.
Most fb apps works, but I have problem with mplayer.
The init works but the video is badly displayed.
I have investigated the problem and found, that for my laptop mode 
1280x800-32.

The ioctl on /dev/fb0 FBIOGET_VSCREENINFO returns.
var.bits_per_pixel=32
var.transp.length = 0.

So the mplayer thinks we are in 24 bit mode (maybe this is bug in mplayer, 
because bits_per_pixel is 32).

But next I have checked it with kernel vesafb and for same mode 
(1280x800-32, vga=0x362 )
The fb ioctl returns
var.bits_per_pixel=32
var.transp.length = 8.

So is this intentionally made so. Because I think this mode use only red, 
green,blue and no transp. But for one pixel you must write 4 bytes. (so 
transp is not used).

