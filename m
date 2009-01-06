Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbZAFRlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbZAFRlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZAFRlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:41:13 -0500
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:55201 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZAFRlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:41:12 -0500
X-Greylist: delayed 1909 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 12:41:12 EST
Message-ID: <49639039.4060708@cs.columbia.edu>
Date: Tue, 06 Jan 2009 12:09:13 -0500
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add in_execve flag into task_struct.
References: <200901060514.n065E462074929@www262.sakura.ne.jp> <20090106155829.GA9773@us.ibm.com>
In-Reply-To: <20090106155829.GA9773@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
>> Serge,
>>
>> James is now reviewing TOMOYO Linux patch and he is caring about
>> your comment below.
>>
>> Serge E. Hallyn wrote:
>>> I don't like the 'in_exec' bit in the task_struct, but adding LSM hooks
>>> to let just TOMOYO mark whether you're in exec seems even uglier.
>> Let me (once again) ask your comment on 'in_exec' approach
>> originally suggested by David Howells ( http://lkml.org/lkml/2008/10/2/127 ).
> 
> I still don't like it.  Now I gather the reason for this is that you
> want to allow a less trusted domain to execute a file (in a new domain)
> without giving it the right to read it?  I'd be interested in hearing
> whether others think that's a worthy goal.

I assume this has been asked and answered by whats the advantage of this
in_exec flag over a single function that set the security domain, oncee
at the beginning of exec to set the new domain (B) and once in the
fail/exit path to reset it back (to A) in case of failure.

the only difference I can see is that you want what is basically a 3rd
security domain of "execing B".

The question would then be, why is "execing B" different than B itself?

otherwise, the same changes you do to set/unset the in_exec flag could
be used to set and reset the security domains.

it just seems weird to say that we are technically in security domain A,
but are going to treat the process as if its in security domain B when
you can just as easily put it in security domain B and put it back in
security domain A if the operation fails.

but again, I could very well be missing something.
