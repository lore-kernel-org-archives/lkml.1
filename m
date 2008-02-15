Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYBOTYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYBOTYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYBOTYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:24:45 -0500
Received: from mail.tmr.com ([64.65.253.246]:40962 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYBOTYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:24:44 -0500
Message-ID: <47B5E743.3000101@tmr.com>
Date: Fri, 15 Feb 2008 14:25:55 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andi Kleen <andi@firstfloor.org>,
       Jasper Bryant-Greene <jasper@unix.geek.nz>,
       rzryyvzy <rzryyvzy@trashmail.net>, linux-kernel@vger.kernel.org
Subject: Re: Is there a "blackhole" /dev/null directory?
References: <20080214093051.7240852AB0E31@trashmail.net> <1202981957.10928.17.camel@phobos.jasper.bg> <p73pruz27mk.fsf@bingen.suse.de> <Pine.LNX.4.64.0802141553400.694@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802141553400.694@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Feb 14 2008 10:46, Andi Kleen wrote:
>> Jasper Bryant-Greene <jasper@unix.geek.nz> writes:
>>> This could be done fairly trivially with FUSE, and IMHO is a good use
>>> for FUSE because since you're just throwing most data away, performance
>>> is not a concern.
> 
> There is a much more interesting 'problem' with a "/dev/null directory".
> 
> Q: Why would you need such a directory?
> A: To temporarily fool a program into believing it wrote something.

Also: to let a program believe it was creating files which are used to 
hold the written data. Otherwise /dev/null would probably be the solution.
> 
> Q: Should all files disappear? (e.g. "unlink after open")
> A: Maybe not, programs may stat() the file right afterwards and
>    get confused by the "inexistence".

I think what is going to happen is that files created behave as if they 
are the result of a mknod resulting in a /dev/null clone.
> 
> Q: What if a program attempts to mkdir /dev/nullmnt/foo to just
>    create a file /dev/nullmnt/foo/barfile?
> A: /dev/nullmnt/foo must continue to exist or be accepted for a while,
>    or perhaps for eternity.

The directory structure can persist, it's the writing of data which can 
be avoided.

Real example:

A program which reads log files and prepares a whole raft of reports in 
a directory specified. If you just want to see the summary (stdout) and 
exception notices (stderr) having a nulldir would avoid the disk space 
and i/o load if you were just looking at the critical output rather than 
the analysis.

Yes, if this was an original program requirement it would or should have 
been a feature. Real world cases sometimes use tools in creative ways.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
