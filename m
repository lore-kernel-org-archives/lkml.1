Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZJNROf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZJNROf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZJNROe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:14:34 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:50741 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZJNROc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=c/jCGEXmrDrU40gOvMiRyw3XINo6z+4/ZjJL24pXBIEq1h8aM/fhCh8UpI7kqIbbtb
         2oABHchd5fR4LG/51DAONPCdAVK2NBcQwuxCoRYFIGjgiI0Fsfkn/L7qeMIEQDh/ShOe
         /E8eeS3pVpulF0ScuncphXtcBnC1scL39ztpI=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Subject: Re: [tip:bkl/drivers] drivers: Remove BKL from misc_open
Date: Wed, 14 Oct 2009 19:12:39 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-tip-commits@vger.kernel.org
References: <20091010153349.237173041@linutronix.de> <alpine.LFD.2.00.0910141816020.9428@localhost.localdomain> <200910141854.49418.arnd@arndb.de>
In-Reply-To: <200910141854.49418.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910141912.40190.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009, Arnd Bergmann wrote:

> arch/mips/basler/excite/excite_iodev.c
> drivers/char/rtc.c
> drivers/infiniband/core/ucma.c
> drivers/s390/char/vmcp.c
> fs/dlm/user.c
> kernel/power/user.c
> arch/x86/kernel/apm_32.c
> drivers/char/nvram.c
> drivers/hwmon/fschmd.c

It turns out that these are all ok, the BKL was removed after
the pushdown.

> drivers/gpu/vga/vgaarb.c
> drivers/hwmon/lis3lv02d.c
> fs/cachefiles/daemon.c
> fs/fuse/cuse.c
> net/rfkill/core.c
> drivers/staging/android/binder.c
> drivers/staging/dream/qdsp5/audio_aac.c
> drivers/staging/dream/qdsp5/audio_evrc.c
> drivers/staging/dream/qdsp5/audio_in.c
> drivers/staging/dream/qdsp5/audio_out.c
> drivers/staging/dream/qdsp5/snd.c
> drivers/staging/dream/smd/smd_qmi.c
> drivers/staging/panel/panel.c

These are new drivers that were merged after the pushdown
and should be looked at, though I don't expect that any of
them to need it because none of them use the locked ioctl
method or any other form of BKL.

> drivers/isdn/mISDN/timerdev.c

This one implicitly holds the BKL in both open and ioctl,
it's probably not required but I didn't look closely.

	Arnd <><
