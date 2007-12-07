Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbXLGLsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbXLGLsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXLGLry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:47:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:34578 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXLGLrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:to:cc:subject:references:in-reply-to:message-id:lines:user-agent:mime-version:content-type:from:date;
        b=QYU1MpJZbPu6LMzCJQSqR9rhZ8RoSh9JQF9NT7MhVET2r7eBFcS8LVB/s0svyUboQsnGMWSdHJxgX3OhxyYnkXtC+LfRAM4PkyR+c17wMhFmIeh3Z6pX/Hik12tWlCEv4ldJOQ19KwyM/Na0tjI9kwMFoN92059OrhkbVHVQBl8=
To: Al Boldi <a1426z@gawab.com>
Cc: Andreas Ericsson <ae@op5.se>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: git guidance
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com>
	<200712070737.18519.a1426z@gawab.com> <475906F7.5010309@op5.se>
	<200712071353.11654.a1426z@gawab.com>
In-Reply-To: <200712071353.11654.a1426z@gawab.com>
Message-ID: <m3prxiu3oo.fsf@roke.D-201>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Jakub Narebski <jnareb@gmail.com>
Date: Fri, 07 Dec 2007 03:47:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> writes:
> Andreas Ericsson wrote:

>> So, to get to the bottom of this, which of the following workflows is it
>> you want git to support?
>>
>> ### WORKFLOW A ###
>> edit, edit, edit
>> edit, edit, edit
>> edit, edit, edit
>> Oops I made a mistake and need to hop back to "current - 12".
>> edit, edit, edit
>> edit, edit, edit
>> publish everything, similar to just tarring up your workdir and sending
>> out ### END WORKFLOW A ###
>>
>> ### WORKFLOW B ###
>> edit, edit, edit
>> ok this looks good, I want to save a checkpoint here
>> edit, edit, edit
>> looks good again. next checkpoint
>> edit, edit, edit
>> oh crap, back to checkpoint 2
>> edit, edit, edit
>> ooh, that's better. save a checkpoint and publish those checkpoints
>> ### END WORKFLOW B ###
> 
> ### WORKFLOW C ###
> for every save on a gitfs mounted dir, do an implied checkpoint, commit, or 
> publish (should be adjustable), on its privately created on-the-fly 
> repository.
> ### END WORKFLOW C ###

It looks like it is WORKFLOW A (with the fact that each ',' is file
save stated explicitely rather than implicitely).
 
> For example:
> 
>   echo "// last comment on this file" >> /gitfs.mounted/file
> 
> should do an implied checkpoint, and make these checkpoints immediately 
> visible under some checkpoint branch of the gitfs mounted dir.
> 
> Note, this way the developer gets version control without even noticing, and 
> works completely transparent to any kind of application.

Why not use versioning filesystem for that, for example ext3cow
(which looks suprisingly git-like, when you take into account that
for ext3cow history is linear and centralized, so one can use date
or sequential number to name commits).

See GitLinks page on Git Wiki, "Other links" section:
  http://www.ext3cow.com/

Version control system is all about WORKFLOW B, where programmer
controls when it is time to commit (and in private repository he/she
can then rewrite history to arrive at "Perfect patch series"[*1*]);
something that for example CVS failed at, requiring programmer to do
a merge if upstream has any changes when trying to commit.

[*1*] I have lost link to post at LKML about rewriting history to
      arrive at perfect patch _series_. IIRC I have found it first
      time on this mailing list. I would be grateful for sending this
      link if you have it. TIA.

-- 
Jakub Narebski
ShadeHawk on #git
