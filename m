Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbXLGUJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbXLGUJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbXLGUJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:09:34 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46744
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbXLGUJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:09:32 -0500
Date: Fri, 7 Dec 2007 13:17:38 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Al Boldi <a1426z@gawab.com>
cc: Andreas Ericsson <ae@op5.se>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: git guidance
In-Reply-To: <200712071353.11654.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0712071259020.12607@asgard.lang.hm>
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com>
 <200712070737.18519.a1426z@gawab.com> <475906F7.5010309@op5.se>
 <200712071353.11654.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007, Al Boldi wrote:

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
>
> For example:
>
>  echo "// last comment on this file" >> /gitfs.mounted/file
>
> should do an implied checkpoint, and make these checkpoints immediately
> visible under some checkpoint branch of the gitfs mounted dir.
>
> Note, this way the developer gets version control without even noticing, and
> works completely transparent to any kind of application.

so if you have a script that does

echo "mail header" >tmpfile
echo "subject: >>tmpfile
echo >>tmpfile
echo "body" >>tmpfile

you want to have four seperate commits

what if you have a perl script

open outfile ">tmpfile";
print outfile "mail header\n";
print outfile "subject:\n\n";
print outfile "body\n";
close ourfile;

how many seperate commits do you think should take place?

what if $|=1 (unbuffered output, so that each print statement becomes 
visable to other programs immediatly)?

what if the file is changed via mmap? should each byte/word written to 
memory be a commit? or when the mmap is closed? or when the kernel happens 
to flush the page to disk?

'recording every change to a filesystem' is a very incomplete definition 
of a goal.

David Lang
