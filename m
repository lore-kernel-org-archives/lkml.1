Return-Path: <linux-kernel-owner+w=401wt.eu-S1763071AbXEYTk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763071AbXEYTk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXEYTkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:40:19 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42823 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbXEYTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:40:17 -0400
Message-ID: <46573B23.1090700@zytor.com>
Date: Fri, 25 May 2007 12:38:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain> <46572DAF.1000108@zytor.com> <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>
> 
>   f() __attribute__((noreturn)) ;
> 
> you get:
> 
>   warning: data definition has no type or storage class
> 
> but gcc doesn't complain if you declare it thusly:
> 
>   __attribute__((noreturn)) f() ;
> 
> that strikes me as a flaw in gcc, no?
> 

Doesn't matter.  gcc accepts "void __attribute__((noreturn)) f();", and
thus, one can define:

#define __noreturn void __attribute__((noreturn))

... and declare functions as:

__noreturn f();

... which is the syntactially sane way of doing it.

	-hpa
