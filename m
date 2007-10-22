Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbXJVX0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbXJVX0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXJVX0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:26:43 -0400
Received: from gw.goop.org ([64.81.55.164]:50456 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXJVX0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:26:42 -0400
Message-ID: <471D31B2.6060009@goop.org>
Date: Mon, 22 Oct 2007 16:26:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Al Viro <viro@ftp.linux.org.uk>, WANG Cong <xiyou.wangcong@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
References: <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking> <20071022113600.GA8181@ftp.linux.org.uk> <20071022122504.GL2998@hacking> <20071022124322.GB8181@ftp.linux.org.uk> <20071022124551.GA7438@elte.hu> <471D2ECC.6090209@goop.org> <20071022231927.GA30814@elte.hu>
In-Reply-To: <20071022231927.GA30814@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> we should kill it there too.
>>>
>>> the only place where we should _please_ keep those annotations are for 
>>> functions that get called from assembly code. This makes life immensely 
>>> easier for -pg (CONFIG_FUNCTION_TRACING) kernels.
>>>       
>> Should we re-add them for the function pointers in asm-x86/paravirt.h?
>>     
>
> yes, yes, yes. :-) It was a nightmare to sort it out in -rt (and still 
> is). It's also good documentation - it pinpoints functions that are 
> called from assembly.
>
>   
>> Andi argued we should remove them since x86 is unconditionally regparm 
>> now anyway - and they're pretty ugly syntactically.
>>     
>
> Sure, it doesnt make things prettier, but i didnt see any particular 
> ugliness.

One thought I had is that "fastcall" doesn't really mean the right
thing.  The speed or otherwise of the call is a side-effect, but what we
really mean is something like "regparm".  Ie, document the actual
calling convention used, rather than an effect of the calling convention.

I guess "fastcall" has enough history now.

    J
