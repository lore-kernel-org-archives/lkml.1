Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZFPKAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZFPKAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZFPJ7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:59:53 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:35288 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbZFPJ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:59:52 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [x86] Build error at arch/x86/boot/bioscall.S
Date: Tue, 16 Jun 2009 04:59:50 -0500
User-Agent: KMail/1.9.9
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
References: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp> <200906160825.n5G8PYRu020230@www262.sakura.ne.jp> <20090616093056.GD6270@cr0.nay.redhat.com>
In-Reply-To: <20090616093056.GD6270@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906160459.53065.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue June 16 2009, Amerigo Wang wrote:
> On Tue, Jun 16, 2009 at 05:25:34PM +0900, Tetsuo Handa wrote:
> >Amerigo Wang wrote:
> >> How about:
> >> 
> >> - movw 68(%esp), %di
> >> + movzwl %sp, %ebx
> >> + movw 68(%ebx), %di
> >> 
> >> ? Does this work?
> >No.
> >
> >arch/x86/boot/bioscall.S: Assembler messages:
> >arch/x86/boot/bioscall.S:69: Error: `68(%ebx)' is not a valid 16 bit base/index expression
> >make[1]: *** [arch/x86/boot/bioscall.o] Error 1
> >make: *** [bzImage] Error 2
> 
> Ok, how about:
> 
> - movw 68(%esp), %di
> + addl $68, %esp
> + popw %di
> + subl $66, %esp
> 

I do hope you have interrupts disabled around that chunk.
Just how old is the toolchain (some didn't do 16bit worth a sh..)?

Mike

> ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


