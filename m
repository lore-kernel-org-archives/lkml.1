Return-Path: <linux-kernel-owner+w=401wt.eu-S1761012AbXEJMWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012AbXEJMWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbXEJMWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:22:41 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:11184 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbXEJMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=N74Jz/B/wHkGsomxvQmQna9j5cp9cCD1V6UckDSyNzKFsB4R9olkkcwt6qgJm2yNs9UtBqT1NnT+UrF2lf8AnpWJzqXfa8GnQOK9zQthQQbwwEVgihUDu4Oe+sSEYaTEn2QTKBU76V13SkQ6UOBP3NTiRFaj/H0EYEj9Hp4JA0c=
Date: Thu, 10 May 2007 14:21:29 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it, dtor@mail.ru
Subject: ixp4xx compile error (was Re: 2.6.21-mm2)
Message-ID: <20070510122129.GC17402@slug>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509012322.199f292b.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 01:23:22AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/
> 
Hi all,

I've got this compile error while building arm ipx4xx:

  CC [M]  drivers/input/misc/ixp4xx-beeper.o
drivers/input/misc/ixp4xx-beeper.c: In function 'ixp4xx_spkr_event':
drivers/input/misc/ixp4xx-beeper.c:54: error: 'input_dev' undeclared (first use in this function)
drivers/input/misc/ixp4xx-beeper.c:54: error: (Each undeclared identifier is reported only once
drivers/input/misc/ixp4xx-beeper.c:54: error: for each function it appears in.)
make[3]: *** [drivers/input/misc/ixp4xx-beeper.o] Error 1
make[2]: *** [drivers/input/misc] Error 2
make[1]: *** [drivers/input] Error 2
make: *** [drivers] Error 2

Following patch fixes the problem.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

--- a/drivers/input/misc/ixp4xx-beeper.c	2007-05-10 08:00:53.000000000 +0200
+++ b/drivers/input/misc/ixp4xx-beeper.c.ori	2007-05-10 07:59:56.000000000 +0200
@@ -51,7 +51,7 @@
 
 static int ixp4xx_spkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
-	unsigned int pin = (unsigned int) input_get_drvdata(dev);
+	unsigned int pin = (unsigned int) input_get_drvdata(input_dev);
 	unsigned int count = 0;
 
 	if (type != EV_SND)
