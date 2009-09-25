Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbZIYGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbZIYGtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 02:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZIYGtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 02:49:19 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:36208 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZIYGtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 02:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=qEppsC1vOfSeLz1FAutm0s0IMFzAMxlU9TdNNbk3ZiQmAC309F1KWM6myVt25JYFeP
         AnsXSIdkzCYKsS2sPdNCli4C7W6xM5XWO6fCjV8q5rLnXx7lSxCCOGChbdpDOEmA3P91
         609A7SCuhLpcpjGc3gTtuhRfcLi/VXllimikI=
MIME-Version: 1.0
In-Reply-To: <20090925034557.GA12810@linux-sh.org>
References: <20090925034557.GA12810@linux-sh.org>
Date: Fri, 25 Sep 2009 14:49:22 +0800
Message-ID: <2375c9f90909242349u7daa7b1epae52fb0da6c92b7d@mail.gmail.com>
Subject: Re: [PATCH] module: Fix up CONFIG_KALLSYMS=n build.
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 11:45 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> Starting from commit 4a4962263f07d14660849ec134ee42b63e95ea9a
> "reduce symbol table for loaded modules (v2)", the kernel/module.c build
> is broken with CONFIG_KALLSYMS disabled.
>
>  CC      kernel/module.o
> kernel/module.c:1995: warning: type defaults to 'int' in declaration of 'Elf_Hdr'
> kernel/module.c:1995: error: expected ';', ',' or ')' before '*' token
> kernel/module.c: In function 'load_module':
> kernel/module.c:2203: error: 'strmap' undeclared (first use in this function)
> kernel/module.c:2203: error: (Each undeclared identifier is reported only once
> kernel/module.c:2203: error: for each function it appears in.)
> kernel/module.c:2239: error: 'symoffs' undeclared (first use in this function)
> kernel/module.c:2239: error: implicit declaration of function 'layout_symtab'
> kernel/module.c:2240: error: 'stroffs' undeclared (first use in this function)
> make[1]: *** [kernel/module.o] Error 1
> make: *** [kernel/module.o] Error 2
>
> There are three different issues:
>
>    - layout_symtab() takes a const Elf_Ehdr
>
>    - layout_symtab() needs to return a value
>
>    - symoffs/stroffs/strmap are referenced by the load_module() code
>      despite being ifdefed out, which seems unnecessary given the noop
>      behaviour of layout_symtab()/add_kallsyms() in the case of
>      CONFIG_KALLSYMS=n.
>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> Cc: Jan Beulich <jbeulich@novell.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

Indeed.

Acked-by: WANG Cong <amwang@redhat.com>
