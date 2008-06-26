Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbYFZNpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbYFZNpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYFZNoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:44:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:20795 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbYFZNox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:44:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I6ybSU/Dk4hxhNb6uipSgL+C8SU6LpBPjiVo8UB4rfyAWOP0/bfQxeVG0TH0ryYzIs
         wLU0yNhpT5aQzq9YuS5R3ECy/yzFAzmHpQxEORgKabs06/rdbj3k+X6k7iPG+udfEfOU
         8QZt68EGyr+YMNu+7TEZ7vy0cn3+TGWQqdyLE=
Message-ID: <19f34abd0806260644s30698d34jd227c170aae8278c@mail.gmail.com>
Date: Thu, 26 Jun 2008 15:44:51 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] x86: more header fixes
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080626133047.GA11762@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610214544.GA14824@damson.getinternet.no>
	 <20080618103006.GF15255@elte.hu>
	 <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com>
	 <20080626120202.GH29619@elte.hu>
	 <20080626133047.GA11762@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 3:30 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> Can I ask you to chase all uses of #include <asm-x86/xxx.h>
> and convert them to #include <asm/xxx.h>
>
> When we move include/asm-x86 to arch/x86/include/asm this is needed and
> better to fix these sooner.

Hm. I can't really seem to find many:

./Documentation/lguest/lguest.c:#include "asm-x86/bootparam.h"
./arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>
./arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>
./arch/ia64/ia32/audit.c:#include <asm-x86/unistd_32.h>

..and I don't even know how to fix them. It seems that we might want
to use filesystem links here instead? (Git should be able to handle
that.)

E.g. so that arch/ia64/include/asm/unistd_32.h ->
arch/x86/include/asm/unistd_32.h. Then arch/ia64/ia32/audit.c can
#include <asm/unistd_32.h>.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
