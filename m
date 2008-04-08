Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYDHWPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYDHWPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 18:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYDHWPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 18:15:22 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:60450 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752888AbYDHWPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 18:15:20 -0400
Date: Wed, 9 Apr 2008 00:15:17 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, R.E.Wolff@BitWizard.nl
Subject: Re: [PATCH] drivers/char/specialix.c: stop inlining largish static functions
Message-ID: <20080408221517.GB24755@bitwizard.nl>
References: <200804081244.53894.vda.linux@googlemail.com> <47FBE5C3.1040105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FBE5C3.1040105@gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 11:38:11PM +0200, Jiri Slaby wrote:
> 
> -	static const char *badmagic =
> +	static const char badmagic[] =
>  		KERN_ERR "sx: Warning: bad specialix port magic number for 
>  		device %s in %s\n";
[...]
>  	if (port->magic != SPECIALIX_MAGIC) {
>  		printk(badmagic, name, routine);
>  		return 1;
>  	}

In a galaxy, far, far away, someone thought that this would save
memory. Especially if you print a message multiple times, the compiler
usually doesn't merge the string constants of two copies of: 

	printk (KERN_ERR "Bad magic number...");

Maybe it does now. (I don't think I came up with this. I probably
copied it over from somewhere....)

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
