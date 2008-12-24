Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbYLXBIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbYLXBIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 20:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYLXBHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 20:07:52 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:39626 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752124AbYLXBHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 20:07:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=V0ep5pIUnx3OGYFAk3tgyxiTbACJq9GZ/qBb3zXtlYb/FOp5l3PmRaBCVrzE4W+HXhV/kUwRKKhq8VNmjl6bH7EflTDYL1TgLuQGVtUSSi00gh9Z/qKkRi9atwjdPA0fKtCxPseQY88V2fwE2XQ+LIHTuvlwcVABG5mERHaVsr4=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>, gregkh@suse.de,
       felipe.balbi@nokia.com
Subject: Re: [PATCH] musb: fix DaVinci build again
Date: Tue, 23 Dec 2008 17:07:47 -0800
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, khilman@deeprootsystems.com,
       davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org
References: <200812072341.50012.sshtylyov@ru.mvista.com> <200812230939.00508.david-b@pacbell.net> <49517305.4000100@ru.mvista.com>
In-Reply-To: <49517305.4000100@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812231707.48195.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2008, Sergei Shtylyov wrote:
> > Yeah, I sent a DaVinci build fix patch in plenty of time to
> > be merged for *2.6.27* (!!!!) but still the key parts are
> > missing, and have not managed to make it into mainline.
> 
>   Try breakinjg the patches into smaller pieces next time, so they may 
> get thru the maintainer's sieve more easily. :-)

That wasn't the issue back then.  If you look at

  c767c1c6f1febbd1351cc152bba6e37889322d17

which got merged after 2.6.27 shipped, you'll notice that
someone stripped out the following parts from the original
patch, which were even referenced in the patch comment.

This worked as submitted, but then got broken during merge;
and fixes have been re-sent several times already.

Plus, some other stuff has merged which prevents linking.
Fixes for those parts have been re-sent several times too.

- Dave

============= CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

Build fixes that somehow got stripped out of the earlier build
fix patch ...

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/musb/davinci.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -31,10 +31,11 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/gpio.h>
+
+#include <mach/hardware.h>
+#include <mach/memory.h>
 
-#include <asm/arch/hardware.h>
-#include <asm/arch/memory.h>
-#include <asm/arch/gpio.h>
 #include <asm/mach-types.h>
 
 #include "musb_core.h"
