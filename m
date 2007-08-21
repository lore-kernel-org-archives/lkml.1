Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbXHUSvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbXHUSvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761067AbXHUSuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:50:52 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:45556 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760968AbXHUSuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:50:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18123.13314.43009.263383@stoffel.org>
Date: Tue, 21 Aug 2007 14:50:42 -0400
From: "John Stoffel" <john@stoffel.org>
To: Peter Staubach <staubach@redhat.com>
Cc: John Stoffel <john@stoffel.org>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
In-Reply-To: <46CB1A78.7040102@redhat.com>
References: <20070820225415.GL3956@digitalkingdom.org>
	<18123.5699.405125.137517@stoffel.org>
	<46CB1A78.7040102@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Peter" == Peter Staubach <staubach@redhat.com> writes:

Peter> John Stoffel wrote:
Robin> I'm bringing this up again (I know it's been mentioned here
Robin> before) because I had been told that NFS support had gotten
Robin> better in Linux recently, so I have been (for my $dayjob)
Robin> testing the behaviour of NFS (autofs NFS, specifically) under
Robin> Linux with hard,intr and using iptables to simulate a hang.
>> 
>> So why are you mouting with hard,intr semantics?  At my current
>> SysAdmin job, we mount everything (solaris included) with 'soft,intr'
>> and it works well.  If an NFS server goes down, clients don't hang for
>> large periods of time. 

Peter> Wow!  That's _really_ a bad idea.  NFS READ operations which
Peter> timeout can lead to executables which mysteriously fail, file
Peter> corruption, etc.  NFS WRITE operations which fail may or may
Peter> not lead to file corruption.

Peter> Anything writable should _always_ be mounted "hard" for safety
Peter> purposes.  Readonly mounted file systems _may_ be mounted
Peter> "soft", depending upon what is located on them.

Not in my experience.  We use NetApps as our backing NFS servers, so
maybe my experience isn't totally relevant.  But with a mix of Linux
and Solaris clients, we've never had problems with soft,intr on our
NFS clients.

We also don't see file corruption, mysterious executables failing to
run, etc.  

Now maybe those issues are raised when you have a Linux NFS server
with Solaris clients.  But in my book, reliable NFS servers are key,
and if they are reliable, 'soft,intr' works just fine.

Now maybe if we had NFS exported directories everywhere, and stuff
cross mounted all over the place with autofs, then we might change our
minds.  

In any case, I don't dis-agree with the fundamental request to make
the NFS client code on Linux easier to work with.  I bet Trond (who
works at NetApp) will have something to say on this issue.


John
