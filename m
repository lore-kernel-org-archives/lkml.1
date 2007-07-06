Return-Path: <linux-kernel-owner+w=401wt.eu-S1763563AbXGFTvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763563AbXGFTvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbXGFTva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:51:30 -0400
Received: from gw.goop.org ([64.81.55.164]:59104 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759940AbXGFTva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:51:30 -0400
Message-ID: <468E9D3F.4030406@goop.org>
Date: Fri, 06 Jul 2007 12:51:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Dan Kegel <dank@kegel.com>, linux-kernel@vger.kernel.org,
       Robert Walsh <rjwalsh@durables.org>
Subject: Re: Valgrinding the kernel?
References: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com> <468DD6A5.4020705@goop.org> <20070706172513.GD10670@c2.user-mode-linux.org> <a71bd89a0707061030s15572cj49cb748bf274593b@mail.gmail.com> <20070706194252.GA12311@c2.user-mode-linux.org>
In-Reply-To: <20070706194252.GA12311@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Fri, Jul 06, 2007 at 10:30:19AM -0700, Dan Kegel wrote:
>   
>> Could you give it a shot?
>>     
>
> OK, after ripping out the code that broke valgrind last time (patch
> below), I get this:
>
> ==27590== Warning: set address range perms: large range 516194304, a 0, v 0
>   

Hm, wonder what that is...

> vex x86->IR: unhandled instruction bytes: 0xF3 0xAF 0x74 0x9
> ==27590== Your program just tried to execute an instruction that Valgrind
> ==27590== did not recognise.  There are two possible reasons for this.
> ==27590== 1. Your program has a bug and erroneously jumped to a non-code
> ==27590==    location.  If you are running Memcheck and you just saw a
> ==27590==    warning about a bad jump, it's probably your program's fault.
> ==27590== 2. The instruction is legitimate but Valgrind doesn't handle it,
> ==27590==    i.e. it's Valgrind's fault.  If you think this is the case or
> ==27590==    you are not sure, please let us know.
> ==27590== Either way, Valgrind will now raise a SIGILL signal which will
> ==27590== probably kill your program.
> ==27590== 
>
>   
>> Maybe the problems after that will be more pedestrian.
>>     
>
> Doesn't look like it.
>
> FWIW, that instruction is repz scas.  In an earlier valgrind effort in
> 2002, I hit repe scas
> (http://www.goop.org/~jeremy/valgrind/76-repe-scas.patch), so maybe
> something similar is needed here.
>   

The virtual CPU code has been competely rewritten since then.  If its a 
non-gcc generated instruction, its possible the new code 
parser/generator hasn't been taught to deal with it.

>> I'm willing to focus a little effort on this.
>>     
>
> I guess you'll have to fix valgrind's various bugs.  See, simple :)
>   

Exactly ;)

    J
