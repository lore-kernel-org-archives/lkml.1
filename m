Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZD1IcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZD1IcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZD1IcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:32:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:55328 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbZD1IcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:subject:date:mime-version:content-type
         :content-transfer-encoding:x-priority:x-msmail-priority:x-mailer
         :x-mimeole;
        b=FlcbI1bUjrS1Qxry6Tid6eOV85VgZuj6Q2v01rmF6I/Sxr2Fi4CcqH++tVWKIzcP/C
         YM2hwPpAy0yd0bPCCbDv8H/2mKk9LHxhEUP025ZQeKQ+vvdoUjo57Iutgd/TwjbYqHVk
         WL2wjMpgh44LoqEO9D3ODlAxZR4gfvoPC28Hc=
Message-ID: <8563BBE2A1F848B3B98C1A5FAE08BD09@avitech.sk>
From: "Peter Hanzel" <hanzelpeter@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>
Subject: KMS + fb + FBIOPUT_VSCREENINFO
Date: Tue, 28 Apr 2009 10:32:34 +0200
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

I have tried DRM with intel KMS and it is workiing. I am using only 
framebuffer console.
Fbcon initializes 1280x800 mode and it works like a charm.

But when I try to call FBIOPUT_VSCREENINFO on /dev/fb0, it always returns 
EINVAL,
I have checked drivers/gpu/drm/i915/intel_fb.c
and found that

intelfb_check_var        returns -EINVAL     if (var->pixclock == -1 || 
!var->pixclock)
intelfb_set_par             returns -EINVAL    if (var->pixclock != -1) { 
DRM_ERROR("PIXEL CLCOK SET\n");  return

So the FBIOPUT_VSCREENINFO always fails.

So is the change of resolution not supported through FBIOPUT_VSCREENINFO 
call?

Thanks.


