Return-Path: <linux-kernel-owner+w=401wt.eu-S1423001AbXD3FDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423001AbXD3FDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423004AbXD3FDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:03:00 -0400
Received: from smtpout.mac.com ([17.250.248.186]:65535 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423001AbXD3FC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:02:58 -0400
In-Reply-To: <20070429235535.GC19937@thunk.org>
References: <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <20070429235535.GC19937@thunk.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1D675F1C-AEFC-40C6-BFC4-BB3E5205B2FF@mac.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Linux 2.6.21
Date: Mon, 30 Apr 2007 01:02:19 -0400
To: Theodore Tso <tytso@mit.edu>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It might not be bad to write up an email-based BTS-alike bug-tracking  
system just for the Linux kernel.  It should probably even be  
implemented 100% via email at first, with a web-based status viewer  
as a later add-on.  Here's a possible email format:

[kbugger: action1 arg1 arg2 ..., action2 arg1 arg2 ...]

Make it almost totally message-id and thread based, and make it an  
implicit part of LKML (IE: subscribe the kbugger program to LKML).   
People who are flagged "admin" may ban/unban users and make certain  
large-scale changes.  Supported actions:

create, create-parent, create-thread:
   Create a new bug associated with this message.
   The arguments specify the title.
   This would automatically happen for new threads with titles like  
"[BUG] foo: It's broken"

merge:
   Merges the current bug and/or email thread into an existing bug.
   The arguments are a list of bug numbers and/or message-IDs to  
merge together with this one.

prune, prune-parent, prune-thread:
   Prunes a given thread from the current bug.
   Optional argument specifies a referential message-ID

settitle:
   Change the title of the current bug

fixed, broken:
   Mark the bug as fixed or broken in a particular version/configuration
   Arguments are used as opaque strings representing configurations  
where it is known to be fixed or broken.  For example [kbugger: fixed  
2.6.16 2.6.20-x86, broken 2.6.20-ppc] would just store the list of  
strings and statuses.  If the bug was auto-created with a title like  
"[BUG ppc] foo: It's broken" or "[BUG 2.6.20] bar: I dunno", then the  
argument to the [BUG] title portion will be auto-passed to [kbugger:  
broken].

status:
   Get a brief status report on the current bug.

info:
   Get a detailed status report on the current bug.

history:
   Get detailed information about the history of the current bug.   
This only sends the reply to the author.

stop:
   Stop parsing the rest of this email.  Useful when teaching  
somebody about kbugger commands via an email sent to kbugger itself.

The results of the kbugger statements in an email will be sent as a  
reply to the original message and "To:" the original sender, "CC:"- 
ing the targets of the message, so if the original [kbugger: create]  
post went to LKML then the reply will go there as well for people to  
read and for it to be archived by kbugger as part of the status  
history of that bug.  All emails it receives will be autoparsed for  
commands, however it should be coded to ignore all text in emailed  
patches, and it should support the [kbugger: stop] command to halt  
parsing for cases where you need to send plain kbugger commands via  
email.

If somebody was feeling unusually brave they might add some  
keyword<=>author bayesian tracking so that it could automatically  
discover the keywords in emails that particular authors reply to and  
helpfully forward a kbugger info email to that person with a link to  
the archives for the original thread.  If somebody didn't want to  
receive such info messages they could click a link or send a  
[kbugger: no-auto-forward] command to blacklist themselves from  
receiving automatic forwards ([kbugger: auto-forward] to re-enable).   
Maybe even [kbugger: not-for-me ...] and [kbugger: for-me] commands  
which take bug numbers and message-IDs to tune the keyword lists.

I may try working on something like that this week if I get the time.

Cheers,
Kyle Moffett

