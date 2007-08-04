Return-Path: <linux-kernel-owner+w=401wt.eu-S1764882AbXHDNwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764882AbXHDNwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbXHDNwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:52:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:56645 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758956AbXHDNwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:52:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OotgbStTjij4uaqvrB3XVKrbWAu8fTu0XJ4/+YPF3GSxq6fUiUUVVpMKyUR2+1Qr0j5LaVEKK/fy9zKDtZQB7bJ/Q0u5QheBRcFFVAnQy36pparrdOv2bT1f85WN9SKIaReS67L26JEW8JsEsxD1fe9xBhIFXGYVy9PkML0MQdU=
Message-ID: <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>
Date: Sat, 4 Aug 2007 21:52:01 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux 2.6.23-rc2
In-Reply-To: <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	 <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
	 <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> > After resume from s2ram or switching to console from X, my console is
> > messed up on rc1 and rc2. Is there a fix for this?
>
> This is on IBM X60. i915 chipset. No problem on 2.6.22. If this is a
> known problem, than I don't need to bisect all over again.

I managed to bisect down to this commit. Without this, console screen
can resume without video mess.

Thanks,
Jeff.

4fd06960f120e02e9abc802a09f9511c400042a5 is first bad commit
commit 4fd06960f120e02e9abc802a09f9511c400042a5
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Jul 11 12:18:56 2007 -0700

    Use the new x86 setup code for i386

    This patch hooks the new x86 setup code into the Makefile machinery.  It
    also adapts boot/tools/build.c to a two-file (as opposed to three-file)
    universe, and simplifies it substantially.

    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 6560eb5b7e40d93813276544bced8c478f9067f5
fe5f90d9ca08e526559815789175602ba2c51743 M      arch
