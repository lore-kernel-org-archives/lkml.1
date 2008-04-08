Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYDHVi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYDHVi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYDHViT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:38:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:63507 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYDHViS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MVhIyLiAV87KhUwFYFhaLIW/DSnnDwocmcgG/OkSyXQpFEtZEjDr8Z3yJBBnzk1Q4yza7hjv2f1WTRMVequ7obadhLr169an+b6EhH26bG1tepfQX1pyU6cdglFMTA5AAVu90jdSnKso8hl7XA984V7KlWSJ9pKyyVk1z53ZZqg=
Message-ID: <47FBE5C3.1040105@gmail.com>
Date: Tue, 08 Apr 2008 23:38:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, R.E.Wolff@bitwizard.nl
Subject: Re: [PATCH] drivers/char/specialix.c: stop inlining largish static
 functions
References: <200804081244.53894.vda.linux@googlemail.com>
In-Reply-To: <200804081244.53894.vda.linux@googlemail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2008 12:44 PM, Denys Vlasenko wrote:
> Hi Alan,
> 
> drivers/char/specialix.c has unusually large number
> of static inline functions - 22.
> 
> I looked through them. The file is positively inline-happy.
> Inlines with udelay() calls. Inlines with complex loops.
> Nested inlines. Rarely called inlines (e.g. with request_region
> inside).
> 
> This patch removes "inline" from 15 static functions
> (regardless of number of callsites - gcc nowadays auto-inlines
> statics with one callsite).
> 
> Size difference for 32bit x86:
>    text    data     bss     dec     hex filename
>   21669     204    8780   30653    77bd linux-2.6-ALLYES/drivers/char/specialix.o
>   18470     204    8780   27454    6b3e linux-2.6.inline-ALLYES/drivers/char/specialix.o
> 
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

-	static const char *badmagic =
+	static const char badmagic[] =
  		KERN_ERR "sx: Warning: bad specialix port magic number for device %s in %s\n";
-	static const char *badinfo =
+	static const char badinfo[] =
  		KERN_ERR "sx: Warning: null specialix port for device %s in %s\n";


BTW what's this good for? I mean, why we need this as a variable not directly as 
a parameter?



  	if (!port) {
  		printk(badinfo, name, routine);
  		return 1;
  	}
  	if (port->magic != SPECIALIX_MAGIC) {
  		printk(badmagic, name, routine);
  		return 1;
  	}
