Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbYCEBnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbYCEBnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYCEBnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:43:04 -0500
Received: from barikada.upol.cz ([158.194.242.200]:36642 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbYCEBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:43:03 -0500
To: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, vegard.nossum@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Subject: text processing (Re: Google's Summer of Code?)
In-Reply-To: <p73hcfm5ind.fsf@bingen.suse.de>
References: <84144f020803041045i70bbb05l6983bd14c5bcc91a@mail.gmail.com> <alpine.LFD.1.00.0803041127290.12253@woody.linux-foundation.org> <84144f020803041155k222c13ecu13c8c9534ced87e5@mail.gmail.com> <20080304121339.a3b2483f.akpm@linux-foundation.org> <p73hcfm5ind.fsf@bingen.suse.de>
Date: Wed, 5 Mar 2008 03:01:58 +0100
Message-Id: <E1JWixC-0003Ap-V2@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen @ Tue, 04 Mar 2008 21:38:46 +0100:
> Andrew Morton
[]
>> http://kernelnewbies.org/KernelProjects
>>
>> There are surely many more things we could put there.
>>
>> I receive a dribble of emails about the setrlimit64/getrlimit64 one, so
>> people are looking at it, and are looking to do work.  (I haven't usefully
>> responded to those emails, btw - am not sure how my name got on that one -
>> probably Ulrich would be better).
>
> http://marc.info/?l=linux-kernel&m=119981029708530&w=2
>
> is also a candidate. There are still quite a lot of unconverted 
> drivers over.

And you've saw first patch there...



I'd say, that i see similar things here (LKML, kernel), wrt shell usage
and text processing.

* checkpatch instead of hard-armed editors (*The* tools of programmers),
  with one's (linux, glibc, bash, whatever) source-friendly capabilities
  (error/coding-style highlight, easy call-graph, param checking, security
   audit(+audit scripts), etc.)

* linux-2.6/scripts/unifdef.c instead of coding style + simple script
  (reinventing of compilers is a dream of CS professors of all times :)

* much of te `make` based stuff

* text processing, which is source code processing, if we are in
  Open Source, has no place in
  + design (super-macro constructs --> C code),
  + auditing (stupid vmsplice() case *and* first ``fix'')
  + testing (writing source in parallel with constructing userspace
    test programs, based on same source; once all is done, script
    generates/constructs kernel part)

* and perl is everywhere


On my `sed` scripts i was getting (from Sam):

   "Because your shell script is unreadable by normal human beings[*]
   while the perl script for people with a bit of perl fu can read it
   and fix/modify it.

   We want tools that can be maintained and enhanced by most people.

   [*] Normal human beings are people with same level of shell
   scripting/sed skills that I have just to put that straight."

   "Linecount is down but so is maintainability / extendability."

So, no tools or perl is better than nothing?

I don't say, i will solve Andi's quest, i just lost interest. But it is
damn interesting one! One, that many script kiddies will do in minutes,
if they would knew `sed` and a bit of UNIX practice, but not perl, C,
diff, git, etc.

So, teach youngsters about "maintainability / extendability" and "Normal
human beings", or what? OTOH, Who are teachers?

Just two points to show skill mismatch, i.e. for

+ managing/manipulating source,
+ designing, writing, maintaining correct kernel code.

Latter isn't for n00bs, right?

* multi-line grep
    Andi Kleen http://mid.gmane.org/20080109000358.GF2117@one.firstfloor.org

* full and correct greping of linux style function definitions
    Linus Torvalds http://mid.gmane.org/1054519757.161606@palladium.transmeta.com

All in one shot:

# print linux-style function definitions

sed -n '
/^[^[:blank:]#/].*[),]$/{
 /,$/{
 :_start;
   N;
   s=)$=&= ; t_end ; b_start;
 :_end;
 };
p}' kernel/*c | pager

#_____

One may not know `sed` at all (but i glad to explain and share
everything, i know), *patterns* and expressions are key things.

Once you have approved and try-and-buy tested one, everything else is
pure technical thing. Maybe somebody outstanding (like Rusty) can do that
with CPP, i don't know; `sed` is just more familiar thing for this.

Silence in reply i will understand quite right, i might be wrong. I just
can't see all that stuff not having much skilled people
involved/interested.
--
-o--=O`C
 #oo'L O
<___=E M
