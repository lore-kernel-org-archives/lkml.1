Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbXD0Ayl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbXD0Ayl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbXD0Ayl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:54:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298AbXD0Ayg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:54:36 -0400
Date: Thu, 26 Apr 2007 17:54:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: linux-2.6.21-rc7-mm2 fails to compile
Message-Id: <20070426175420.f2caae1a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704262358550.25153@server.thyself>
References: <Pine.LNX.4.64.0704262358550.25153@server.thyself>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 00:00:15 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:

> Output leading up to the error:
> 
>    CC      drivers/macintosh/macio-adb.o
>    LD      drivers/macintosh/built-in.o
>    CC [M]  drivers/macintosh/apm_emu.o
>    CC [M]  drivers/macintosh/therm_windtunnel.o
> drivers/macintosh/therm_windtunnel.c: In function 'therm_of_remove':
> drivers/macintosh/therm_windtunnel.c:462: error: void value not ignored as it 
> ought to be
> drivers/macintosh/therm_windtunnel.c:463: warning: control reaches end of 
> non-void function
> make[2]: *** [drivers/macintosh/therm_windtunnel.o] Error 1
> make[1]: *** [drivers/macintosh] Error 2
> make: *** [drivers] Error 2
> 
> This is on an iMac G3 powerpc.

i2c_del_driver() was changed to reutrn void in the i2c tree.

--- a/drivers/macintosh/therm_windtunnel.c~fix-jdelvare-i2c-i2c-del-driver-returns-void-on-powerpc
+++ a/drivers/macintosh/therm_windtunnel.c
@@ -459,7 +459,8 @@ therm_of_probe( struct of_device *dev, c
 static int
 therm_of_remove( struct of_device *dev )
 {
-	return i2c_del_driver( &g4fan_driver );
+	i2c_del_driver( &g4fan_driver );
+	return 0;
 }
 
 static struct of_device_id therm_of_match[] = {{
_

