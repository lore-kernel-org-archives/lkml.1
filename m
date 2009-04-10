Return-Path: <linux-kernel-owner+w=401wt.eu-S939420AbZDJSOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939420AbZDJSOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937230AbZDJSOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:14:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:52263 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933875AbZDJSOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mf2u4ZfzqqlIWZ6pcaquyBzX6WKtCzoyUlcfiT6Mg+OnBQvAfegrTQuEUvGHwzgmn1
         hMqqR0s1ODBavwEhfDaOTfqDzdqm7Pd4JFoI2wbI/6vnBarWsPOTp06IQP1JqVg8xnIp
         vQggwjPoxQU237Niac9radtXFlfI/walQ+23M=
Date: Fri, 10 Apr 2009 22:14:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
Message-ID: <20090410181409.GE8204@lenovo>
References: <1239385015.3169.15.camel@ht.satnam> <20090410175545.GB16843@elf.ucw.cz> <1239386729.9282.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239386729.9282.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jaswinder Singh Rajput - Fri, Apr 10, 2009 at 11:35:29PM +0530]
| On Fri, 2009-04-10 at 19:55 +0200, Pavel Machek wrote:
| > On Fri 2009-04-10 23:06:55, Jaswinder Singh Rajput wrote:
| > > Impact: fix overflow
| > 
| > > Constant 0x123456789abcdef0 is so big for a long.
| > > So using saved_magic 0x12345678 for both 32 and 64 bit.
| > 
| > Have you tested the patch? I have feeling that this is tested from
| > assembly... Plus it is only set to long constant on 64-bit, so I don't
| > think you are fixing anything. And if your code is correct the
| > variable is write only...
| > 
| 
| I have tested this:
| 1.  CHECK   arch/x86/kernel/acpi/sleep.c
| arch/x86/kernel/acpi/sleep.c:107:16: warning: constant 0x123456789abcdef0 is so big it is long
| 
| 2. On 64 bit machine box:
| 	long l1;
| 
| 	l1 = 0x123456789abcdef0;
| 	printf("0x%16x : ", l1);
| 
| Output: 0x        9abcdef0
| 
| --
| JSR
| 
| 

"0x%lx" will help

        Cyrill
