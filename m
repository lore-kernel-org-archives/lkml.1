Return-Path: <linux-kernel-owner+w=401wt.eu-S1161232AbXDWSgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbXDWSgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161331AbXDWSgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:36:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:20204 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161232AbXDWSgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:36:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=d4EWI9bWc5cZubJDS+UHDCfcu7km/Gh+nytxCTCzR5ZxmpmqeyNSOxaBSNB7jNhzOnzNeGLtxpZedNDjUxXfuukpKa9SHzojud+lwt3JqCl59K3dtrZrWAkFfgmv8aaiQ9owk3G7DsxqXKo0bUFgXCFoPLU5altY5pOFDfh4A0g=
Date: Mon, 23 Apr 2007 22:36:20 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?utf-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Issue with rdmsr_on_cpu
Message-ID: <20070423183620.GA5835@martell.zuzino.mipt.ru>
References: <462CF462.10907@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <462CF462.10907@interia.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 08:01:06PM +0200, Rafał Bilski wrote:
> Some time ago I have written hwmon driver for Centaur C7
> processors. Nobody was interested in testing it, so it
> spend long time on my harddisk. Recently one person wanted
> to test it with 2.6.21-rc7. Unfortunatly compile fails.
> I don't understand why. I'm not using rdmsr_on_cpu
> functions. Code is assuming that only one CPU is present
> and using rdmsr function direcly. Is this no longer
> possible? Do I have to #include something?

asm/types.h in the beginning of asm/msr.h should do the trick.

> Build log attached.
> I'm not attaching code because error isn't reported in my
> source file, but in Linux includes. My compiler is GCC 4.1.2
> and kernel isn't SMP.
>
> Please CC me.
> 
> Thanks
> Rafał
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CC [M]  drivers/hwmon/c7temp.o
> In file included from drivers/hwmon/c7temp.c:19:
> include/asm/msr.h:90: error: expected declaration specifiers or '...' before 'u32'
> include/asm/msr.h:90: error: expected declaration specifiers or '...' before 'u32'
> include/asm/msr.h:90: error: expected declaration specifiers or '...' before 'u32'
> include/asm/msr.h: In function 'rdmsr_on_cpu':
> include/asm/msr.h:92: error: 'l' undeclared (first use in this function)
> include/asm/msr.h:92: error: (Each undeclared identifier is reported only once
> include/asm/msr.h:92: error: for each function it appears in.)
> include/asm/msr.h:92: error: 'h' undeclared (first use in this function)
> include/asm/msr.h:92: error: 'msr_no' undeclared (first use in this function)
> include/asm/msr.h:92: error: invalid lvalue in asm output 0
> include/asm/msr.h:92: error: invalid lvalue in asm output 1
> include/asm/msr.h: At top level:
> include/asm/msr.h:94: error: expected declaration specifiers or '...' before 'u32'
> include/asm/msr.h:94: error: expected declaration specifiers or '...' before 'u32'
> include/asm/msr.h:94: error: expected declaration specifiers or '...' before 'u32'
> include/asm/msr.h: In function 'wrmsr_on_cpu':
> include/asm/msr.h:96: error: 'msr_no' undeclared (first use in this function)
> include/asm/msr.h:96: error: 'l' undeclared (first use in this function)
> include/asm/msr.h:96: error: 'h' undeclared (first use in this function)

