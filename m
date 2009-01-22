Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZAVCVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZAVCVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbZAVCV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:21:29 -0500
Received: from mail.perle.com ([216.129.13.248]:1029 "EHLO MAILV6.PERLE.COM"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755413AbZAVCV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:21:29 -0500
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 60/80] tty: extract the pty init time special cases
Sensitivity: 
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF87B1346C.1E63B3D8-ON85257546.0006F3DA-85257546.000CF300@perle.com>
From: bmckinlay@perle.com
Date: Wed, 21 Jan 2009 21:16:58 -0500
X-MIMETrack: Serialize by Router on MAILV6/Perle(Release 6.5.6FP3|March 27, 2008) at 01/21/2009
 09:16:40 PM,
	Serialize complete at 01/21/2009 09:16:40 PM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My question/comment is in regards to the following patch indicated below 
that was posted on October 13, 2008.
 
>  From Alan Cox <>
> Subject       [PATCH 60/80] tty: extract the pty init time special cases
> Date  Mon, 13 Oct 2008 10:42:39 +0100
>
> From: Alan Cox <alan@redhat.com>
> 
> The majority of the remaining init_dev code is pty special cases. We 
> refactor this code into the driver->install method.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---
>  drivers/char/pty.c    |  126 ++++++++++++++++++++++++++++---
>  drivers/char/tty_io.c |  198 
+++++++++++++++++--------------------------------
>  include/linux/tty.h   |    5 +
>  3 files changed, 187 insertions(+), 142 deletions(-)
> 

This patch seems to break any other pseudo tty drivers, (ie driver->type 
==TTY_DRIVER_TYPE_PTY) since not all the tty functions needed for the 
driver's new driver->install method are exported from tty_io.c.  The 
function symbols that need to be exported from /drivers/char/tty_io.c are 
the following:

   EXPORT_SYMBOL_GPL(alloc_tty_struct);
   EXPORT_SYMBOL_GPL(free_tty_struct);
   EXPORT_SYMBOL_GPL(tty_init_termios);
   EXPORT_SYMBOL_GPL(initialize_tty_struct);

I've added these lines and recompiled a 2.6.28 kernel along with adding 
new driver->install methods to my master and slave pseudo tty driver and 
it seems to work fine now.

Before I go ahead and post a patch, does anyone see any problems with 
this?




