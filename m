Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYGONUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYGONUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbYGONUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:20:15 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:2882 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbYGONUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=vuasc3H/f3PnMqgEJnEYdA3J7dtaSiCsy5VUCstJiW1LXCYC/G8urPqLkqT+x+G1Fb
         I4IJ8y94V6oAJF2aQgsTAOWFWdKJ9aFQqhH8+nisENeyaDGlzx+hPCaTdYj0+HYSZboj
         wVbzf6wgN4//vLvo9iMNvsCEvY20U5MbRm5vI=
Date: Tue, 15 Jul 2008 06:20:05 -0700
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, sam@ravnborg.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: binutils 2.18.50.0.8 frv build error
Message-ID: <20080715132005.GA6517@lucon.org>
References: <20080715121327.GA24533@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715121327.GA24533@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "H.J. Lu" <hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 03:13:27PM +0300, Adrian Bunk wrote:
> Toolchain:
> - gcc 4.3.1
> - binutils 2.18.50.0.7 and 2.18.50.0.8
> - configured for frv-linux
> - kernel 2.6.26
> 
> Builds fine when using binutils 2.18.50.0.7,
> but fails as follows with binutils 2.18.50.0.8:
> 
> <--  snip  -->
> 
> ...
>   HOSTCC  scripts/kallsyms
>   CC      init/main.o
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   CC      init/do_mounts.o
>   LD      init/mounts.o
>   CC      init/noinitramfs.o
>   LD      init/built-in.o
> frv-linux-ld: init/mounts.o: compiled with -fpic and linked with modules that use non-pic relocations
> frv-linux-ld: failed to merge target specific data of file init/mounts.o
> make[2]: *** [init/built-in.o] Error 1
> 
> <--  snip  -->
> 
> Complete verbose log below.
> 
> Any hints what's going wrong?
> 
> cu
> Adrian
> 
> 

...

>    frv-linux-ld    -r -o init/built-in.o init/main.o init/version.o init/mounts.o init/noinitramfs.o 
> frv-linux-ld: init/mounts.o: compiled with -fpic and linked with modules that use non-pic relocations
> frv-linux-ld: failed to merge target specific data of file init/mounts.o
> make[1]: *** [init/built-in.o] Error 1
> make: *** [init] Error 2

This regression was introduced between 2008-05-02 10:10am and
2008-07-09 5:45pm PDT.  Does ld from binutils 2.18.50.0.7 work
on the same init/main.o init/version.o init/mounts.o
init/noinitramfs.o? If yes, please open a bug report at

http://www.sourceware.org/bugzilla/

with those .o files. If not, please find out why.

Thanks.



H.J.
