Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYJWLPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYJWLPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYJWLOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:14:51 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:57233 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbYJWLOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:14:50 -0400
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.2] Unnamed entry appears in/sys/module/usbcore/parameters/ .
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200810210838.m9L8cegu033608@www262.sakura.ne.jp>
	<20081021170002.GA24940@kroah.com>
	<200810221951.JHF56206.JFQFMFSVtLOHOO@I-love.SAKURA.ne.jp>
	<20081023051113.GA7719@kroah.com>
In-Reply-To: <20081023051113.GA7719@kroah.com>
Message-Id: <200810232014.HCE57837.MVJtOFQOFHFOSL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 23 Oct 2008 20:14:47 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tested 2.6.27.3 on Debian Sarge. I got the same result.

So, I tried to produce different results.

I pruned declaration of module_param(usbfs_snoop) like

  static int usbfs_snoop;
  /*
  module_param(usbfs_snoop, bool, S_IRUGO | S_IWUSR);
  MODULE_PARM_DESC(usbfs_snoop, "true to log all usbfs traffic");
  */

and I got the below result.

  # ls -ail /sys/module/usbcore/parameters/
  total 0
  189 drwxr-xr-x  2 root root    0 Oct 24  2008
  189 drwxr-xr-x  2 root root    0 Oct 24  2008 .
  188 drwxr-xr-x  4 root root    0 Oct 24  2008 ..
  190 -rw-r--r--  1 root root 4096 Oct 24  2008 autosuspend
  192 -r--r--r--  1 root root 4096 Oct 24  2008 blinkenlights
  193 -rw-r--r--  1 root root 4096 Oct 24  2008 old_scheme_first

This time, 'use_both_schemes' entry became no-name.

I added declaration of module_param(usbfs_aaaaa) and module_param(usbfs_zzzzz)
like

  static int usbfs_aaaaa;
  module_param(usbfs_aaaaa, bool, S_IRUGO | S_IWUSR);
  MODULE_PARM_DESC(usbfs_aaaaa, "true to log all usbfs traffic");
  
  static int usbfs_snoop;
  module_param(usbfs_snoop, bool, S_IRUGO | S_IWUSR);
  MODULE_PARM_DESC(usbfs_snoop, "true to log all usbfs traffic");
  
  static int usbfs_zzzzz;
  module_param(usbfs_zzzzz, bool, S_IRUGO | S_IWUSR);
  MODULE_PARM_DESC(usbfs_zzzzz, "true to log all usbfs traffic");

and I got the below result.

  # ls -ail /sys/module/usbcore/parameters/
  total 0
  189 drwxr-xr-x  2 root root    0 Oct 24  2008
  189 drwxr-xr-x  2 root root    0 Oct 24  2008 .
  188 drwxr-xr-x  4 root root    0 Oct 24  2008 ..
  190 -rw-r--r--  1 root root 4096 Oct 24  2008 autosuspend
  192 -r--r--r--  1 root root 4096 Oct 24  2008 blinkenlights
  193 -rw-r--r--  1 root root 4096 Oct 24  2008 old_scheme_first
  195 -rw-r--r--  1 root root 4096 Oct 24  2008 usbfs_aaaaa
  196 -rw-r--r--  1 root root 4096 Oct 24  2008 usbfs_snoop
  194 -rw-r--r--  1 root root 4096 Oct 24  2008 use_both_schemes

This time, 'usbfs_zzzzz' entry became no-name.

Greg KH wrote:
> I really have no idea what is causing this, and can't seem to duplicate
> this here at all.
It seems to me that somebody is overwriting (or truncating) at address
of module_param(usbfs_snoop) .

Is there a way to change the address of module_param() defined by
usbcore module?

Regards.
