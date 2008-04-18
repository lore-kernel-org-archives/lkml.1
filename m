Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYDRPlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYDRPlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYDRPlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:41:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:16996 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYDRPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=iadYeWHIw6GL0RRQ6O4xX3eCcPxLAYPuRbvl/EjZRLWXs/hEaChfw6DpAzlhyTNM3vXf7g2pCqSUOom66wNX/ZLQhpSmPUlvW9BN4TFZtiYM1pRwqwh5nqiqRoGwOmi6GpafMPNc/w+jnIDlG2r5/ws+RFbaidtSfvHdAiXAFaQ=
Message-ID: <4808D1F4.7050705@gmail.com>
Date: Fri, 18 Apr 2008 18:53:08 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-man@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Petr Gajdos <pgajdos@suse.cz>, michael.kerrisk@gmail.com
Subject: core_pattern pipe documentation
References: <cfd18e0f0804151409q178addf4t4c6cba683bd0bff4@mail.gmail.com> <cfd18e0f0804151411x62080f10y833493db7f1b8cfd@mail.gmail.com> <48051FBA.60503@firstfloor.org>
In-Reply-To: <48051FBA.60503@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

I wrote the following description of the core_pattern pipe feature.  Does this
seem okay?

   Piping core dumps to a program
       Since kernel 2.6.19, Linux supports an  alternate  syntax
       for the /proc/sys/kernel/core_pattern file.  If the first
       character of this file is a pipe  symbol  (|),  then  the
       remainder  of  the line is interpreted as a program to be
       executed.  Instead of being written to a disk  file,  the
       core  dump  is  given  as  standard input to the program.
       Note the following points:

       *  The program must be specified using an absolute  path-
          name  (or  a  pathname relative to the root directory,
          /), and must immediately follow the '|' character.

       *  The process created to run the program  runs  as  user
          and group root.

       *  Arguments can be supplied to the program, delimited by
          white space (up to a total line length of 128  bytes).

Cheers,

Michael


Andi Kleen wrote:
> Michael Kerrisk wrote:
>> On Tue, Apr 15, 2008 at 11:09 PM, Michael Kerrisk
>> <mtk.manpages@googlemail.com> wrote:
>>> Hi Andi,
>>>
>>> In 2.6.19 you added the pipiing syntax
>>> (http://lwn.net/Articles/195310/) to core_pattern.  Petr pointed out
>>> that this is not yet documented in core(5), so I set to testing it.
>>>
>>> The change log has the text:
>>>
>>>    The core dump proces will run with the privileges and in the name space
>>>    of the process that caused the core dump.
> 
> My memory is fuzzy but something might have changed this afterwards
> (there were some semantics changes afterwards by other people)  I think
> my original version ran as non root.
> 
> Anyways the reference as usual is the code, not the change log.
> 
>>> This appears not to be true (as tested on 2.6.25-rc8).  Instead the
>>> pipe program is run as root.  I'm not sure what "in the name space of
>>> the process that caused the core dump" means 
> 
> namespace is a concept from plan9. It basically means the tree
> of mounts the current process has access to. On 99+% of the systems
> that is only a single global tree, but there is support for processes
> creating their own name space using clone CLONE_NEWNS and then
> mount/umount/mount --bind etc. Linux VFS had this support for
> some time.
> 
> The whole thing is very obscure but perhaps some more
> coverage in the man pages would be not bad. It seems to move
> slowly out of obscurity now with all the new container work.
> 
> There is some scattered information in Documentation/*. You'll need
> someone else to explain you all the finer details though.
> 
> Also there are lots of different mounts now since a few 2.6 kernels --
> to be honest I don't understand what they are all good for.
> 
> 
> -- I wondered if it might
>>> mean that the current working directory of the program would be the
>>> same as that of the process that caused the core dump.  However that
>>> is not so: the current directory for the pipe program is the root
>>> directory.
> 
> Basically with a different namespace the paths can change completely,
> which can in theory have some unpleasant effects on the core dumper
> script. I skimped this by just always using the same as the process.
> 
> -Andi
> 
> 

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html

