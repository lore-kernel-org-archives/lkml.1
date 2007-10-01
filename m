Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbXJAQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbXJAQ0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXJAQ0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:26:11 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:47981
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXJAQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:26:10 -0400
Date: Mon, 1 Oct 2007 09:27:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Bernd Eckenfels <ecki@lina.inka.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Out of memory management in embedded systems
In-Reply-To: <E1IcGOu-0007sH-00@calista.eckenfels.net>
Message-ID: <Pine.LNX.4.64.0710010916570.20712@asgard.lang.hm>
References: <E1IcGOu-0007sH-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Bernd Eckenfels wrote:

> In article <87odfj5krj.fsf@burp.tkv.asdf.org> you wrote:
>> Make kernel configuration option? (e.g. disable "over commit"
>> mis-feature :-)
>
> # egrep . /proc/sys/vm/overcommit_*
> /proc/sys/vm/overcommit_memory:0
> /proc/sys/vm/overcommit_ratio:50

keep in mind that disabling overcommit will mean that you need to put more 
ram in your embeded system to have it run

there can be very significant saving in ram from the fact that a large 
program can do fork-exec of a small program without having to have enough 
ram in the system for two copies of the large program.

you get even more savings in most systems from the fact that Linux does 
copy-on-write when programs fork instead of allocating (and copying) all 
the memory the program accesses. this allows programs that run multiple 
copies to use the same memory for most of the requirements.

overcommit by default is optimistic that if the program requesting the 
memory actually tries to use it there will be enough (both the fork-exec 
situation and the copy-on-write memory of real forks mean that the system 
ends up useing much less memory then is theoretically allocated).

switching it to be pessimistic (overcommit 2 IIRC) means that the OOM 
handler will never kick in, but it means that programs will be told that 
there isn't any memory when there really is enough for the program to 
work.


if you think the pessimistic mode makes your embeded device deterministic 
enough to avoid OOM go for it, but keep in mind that adding the same 
amount of additional memory would also make the system safe with 
overcommit (if everything works properly). it's only when you would rather 
have the system fail an allocation immedialy rather then running any risk 
of running into trouble later that you want to disable overcommit.

DavidLang
