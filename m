Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZFPJ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZFPJ2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZFPJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:28:42 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:61203 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZFPJ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:28:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s5MF6hnx4lUf04627AlKgvWhUjpKJP4hCD09Tofa8uMgTUQ/bQXHpJd4z5prI3uC/v
         x35cERpLKKxhzPH/ciQQmri08kjk5aufxiSFNihAc74KkZiMDmWB4dN5dWT7gW4h6AP7
         ZUjiQquYoL6noS/mO2XAGpJw1YolUD31QL3T4=
Date: Tue, 16 Jun 2009 17:30:56 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: xiyou.wangcong@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [x86] Build error at arch/x86/boot/bioscall.S
Message-ID: <20090616093056.GD6270@cr0.nay.redhat.com>
References: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp> <20090616081445.GB6270@cr0.nay.redhat.com> <200906160825.n5G8PYRu020230@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906160825.n5G8PYRu020230@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 05:25:34PM +0900, Tetsuo Handa wrote:
>Amerigo Wang wrote:
>> How about:
>> 
>> - movw 68(%esp), %di
>> + movzwl %sp, %ebx
>> + movw 68(%ebx), %di
>> 
>> ? Does this work?
>No.
>
>arch/x86/boot/bioscall.S: Assembler messages:
>arch/x86/boot/bioscall.S:69: Error: `68(%ebx)' is not a valid 16 bit base/index expression
>make[1]: *** [arch/x86/boot/bioscall.o] Error 1
>make: *** [bzImage] Error 2

Ok, how about:

- movw 68(%esp), %di
+ addl $68, %esp
+ popw %di
+ subl $66, %esp

?
