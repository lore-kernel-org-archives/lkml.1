Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbZHAWh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbZHAWh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 18:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZHAWh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 18:37:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60965 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZHAWh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 18:37:56 -0400
Message-ID: <4A74C34F.9050406@zytor.com>
Date: Sat, 01 Aug 2009 15:35:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A7499BA.2000405@zytor.com> <alpine.LFD.2.01.0908011501470.3352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908011501470.3352@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2009 03:04 PM, Linus Torvalds wrote:
> 
> On Sat, 1 Aug 2009, H. Peter Anvin wrote:
>> This is clearly better... now the semi-obvious question becomes if there
>> is any way we can get compiler support to do better and migrate to that
>> as the compiler allows.
> 
> Well, even if we had compiler support, we'd have to basically then wait 
> forever to make sure everybody has a supported compiler. So I think we're 
> better off not worrying too much about that - it's not going to happen any 
> time in the near future.
> 

Well, we'd have to do something like:

#if __GNUC__ < version
/* current code */
#else
/* new code */
#endif

> I've now tested my patch, and it seems to result in a working kernel too. 
> 
>> In particular, if I remember right the problem with using __thread for 
>> percpu was exactly that the current cpuness can change almost anywhere, 
>> unless preemption is disabled.
> 
> That shouldn't matter. If it uses '%gs', it should all just work 
> automatically. But if gcc does something different for thread-local, it's 
> basically useless.
> 

gcc uses %fs by default for __thread (on x86-64) but that can be
overridden.  I believe someone tried to use it, but found that gcc made
the assumption that none of the values could change underneath it, which
caused trouble.  That wouldn't be an issue for variables like "current".

As I said, in the meantime I really do like your patch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

