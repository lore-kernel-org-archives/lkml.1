Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYJZPYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYJZPYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 11:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYJZPX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 11:23:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:32226 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbYJZPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 11:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=SZBirkUnSPqG9vG3ajA5YjZelgaow0EcotwP2Y4sanqXp3gRU0nMwHnQeraf0NeFjS
         NI1/LgQxVcShlmIvS9P9uKeveckXA8QlcwENKhZvlU55ZL1jh4BxVtD6XSoHZG/0tFjt
         sWkGuNc5aPiX/VvAXxv3EhQxBWxPxAHw3y0Tk=
Message-ID: <49048B88.1060807@gmail.com>
Date: Sun, 26 Oct 2008 16:23:52 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Gareth Hughes <gareth@valinux.com>
CC: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@tungstengraphics.com>
Subject: oops in radeon_suspend (mmotm 2008-10-22-17-18)
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this oops occured on suspend of mmotm:
http://decibel.fi.muni.cz/~xslaby/radeon_oops1.png
http://decibel.fi.muni.cz/~xslaby/radeon_oops2.png

radeon_suspend:
movq    288(%rcx), %rax # <variable>.mmio, <variable>.mmio
xorl    %edx, %edx      # tmp68
movq    24(%rax), %rax  # <variable>.handle, <variable>.handle

rax (dev_priv->mmio) is null.
