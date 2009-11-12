Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZKLK5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZKLK5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZKLK5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:57:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:50212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZKLK5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:57:15 -0500
Message-ID: <4AFBEA4B.4070100@kernel.org>
Date: Thu, 12 Nov 2009 19:58:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu> <4AF9C402.9040800@kernel.org> <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain> <4AFA35CB.5030801@kernel.org> <20091111113147.GB7487@elte.hu> <4AFAAC32.4020104@kernel.org> <20091111195751.GA13574@elte.hu> <4AFBDF43.3010703@kernel.org> <20091112103639.GB24684@elte.hu>
In-Reply-To: <20091112103639.GB24684@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

11/12/2009 07:36 PM, Ingo Molnar wrote:
> 
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> Hmmm... The thing is that the nesting isn't that deep there and 
>> breaking string in the middle is something we do quite often.  What 
>> checkpatch warning did you see?
> 
> ( i did not run checkpatch over your commit - i just assumed that the 
>   ugliness was a checkpatch artifact. )
> 
> Breaking strings mid-sentence is something we try not to do. (If you 
> know about places that do it 'quite often' then those places need fixing 
> too.)

Oh... I do that all the time and I see a lot of them around too.

> the git-grep comes up empty because the string was needlessly broken in 
> mid-sentence. Which is a confusing result and which causes people to 
> waste time trying to figure out where the message came from.
> 
> The other messages in this function are fine btw, for example:
> 
>   git grep 'failed to populate'
> 
> will come up with the right place.

While I agree this is a valid reason, I really don't think we should
be restructuring whole code to accomodate long strings on single line.
I think a better way would be to teach grepping tool to match those
broken lines.  It shouldn't be too difficult to put this into ack[1]
and maybe we can have git-ack (that's a bad name for git tho).  I'll
ask ack author nicely.

> ( There are also other reasons why we dont break strings mid-sentence - 
>   it's also less readable to have it on two lines. )

This really depends on personal tastes.  When trying to use long
string literals, there are several choices.

1. Use broken strings.

				printk("blah blah blah blah "
				       "blah blah blah blah\n");

2. Push it into new line and unindent it.

				printk(
	"blah blah blah blah blah blah blah blah\n");

3. Restructure code so that the literal ends up in outer block.

	printk("blah blah blah blah blah blah blah blah\n");

I prefer the first choice.  The third would be nice if it's trivial to
do but I don't think it should dictate the code structure.  The second
one, I don't know.  Some people like that and grep will be happy with
it but it just seems very disturbing to my eyes.

Thanks.

-- 
tejun

[1] http://betterthangrep.com/
