Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYBYIH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYBYIH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYBYIHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:07:13 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:44596 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbYBYIHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:07:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YpReu4yKgVlNntWdQbLpN32h9VVDUqnc6ZJ7mqa9AQ76xsiV6EQgb8RLaIkLXv4koccX9MhPxvzJg2APwu4WEvzN0kANZy/7dVFiiGjypR4zgJY3uNGu+4oPaVnYAZGMMHjcFVADH37eOAMOrlBnvkKqCLPCzIf4uHq/lkrdJIU=
Date: Mon, 25 Feb 2008 11:06:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] x86 - boot/header.S
Message-ID: <20080225080644.GA6744@cvg>
References: <20080223082026.GA6747@cvg> <47C224D8.8070409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C224D8.8070409@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Sun, Feb 24, 2008 at 06:15:52PM -0800]
> Cyrill Gorcunov wrote:
>> Hi Peter, Sam,
>> could you take a look on x86/boot/header.S:280 please?
>> # Zero the bss
>> 	movw	$__bss_start, %di
>> 	movw	$_end+3, %cx
>> 	xorl	%eax, %eax
>> 	subw	%di, %cx
>> 	shrw	$2, %cx
>> 	rep; stosl
>> I wonder why is $_end there instead of $__bss_stop?
>> Well, accroding to vmlinux_32.lsd both _end and __bss_stop
>> are the same BUT __bss_stop is more convenient methink.
>> Would it be usefull to change?
>
> x86/boot/header.S goes with x86/boot/setup.ld and no other linker script.
>
> 	-hpa
>

indeed... :( anyway, setup.ld has the definition of __bss_stop too
though in this case __bss_stop is not equal to _end BUT
[__bss_start;__bss_stop] do cover *bss section anyway.

According to Sam's last post it will not be a problem anymore
'cause of memset further usage.

Thanks for comments, Peter.

		- Cyrill -
