Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbXHUTFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbXHUTFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXHUTFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:05:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbXHUTFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:05:08 -0400
Message-ID: <46CB375B.6050901@redhat.com>
Date: Tue, 21 Aug 2007 15:04:59 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
References: <20070820225415.GL3956@digitalkingdom.org>	<18123.5699.405125.137517@stoffel.org>	<46CB1A78.7040102@redhat.com> <18123.13314.43009.263383@stoffel.org>
In-Reply-To: <18123.13314.43009.263383@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
>>>>>> "Peter" == Peter Staubach <staubach@redhat.com> writes:
>>>>>>             
>
> Peter> John Stoffel wrote:
> Robin> I'm bringing this up again (I know it's been mentioned here
> Robin> before) because I had been told that NFS support had gotten
> Robin> better in Linux recently, so I have been (for my $dayjob)
> Robin> testing the behaviour of NFS (autofs NFS, specifically) under
> Robin> Linux with hard,intr and using iptables to simulate a hang.
>   
>>> So why are you mouting with hard,intr semantics?  At my current
>>> SysAdmin job, we mount everything (solaris included) with 'soft,intr'
>>> and it works well.  If an NFS server goes down, clients don't hang for
>>> large periods of time. 
>>>       
>
> Peter> Wow!  That's _really_ a bad idea.  NFS READ operations which
> Peter> timeout can lead to executables which mysteriously fail, file
> Peter> corruption, etc.  NFS WRITE operations which fail may or may
> Peter> not lead to file corruption.
>
> Peter> Anything writable should _always_ be mounted "hard" for safety
> Peter> purposes.  Readonly mounted file systems _may_ be mounted
> Peter> "soft", depending upon what is located on them.
>
> Not in my experience.  We use NetApps as our backing NFS servers, so
> maybe my experience isn't totally relevant.  But with a mix of Linux
> and Solaris clients, we've never had problems with soft,intr on our
> NFS clients.
>
> We also don't see file corruption, mysterious executables failing to
> run, etc.  
>
> Now maybe those issues are raised when you have a Linux NFS server
> with Solaris clients.  But in my book, reliable NFS servers are key,
> and if they are reliable, 'soft,intr' works just fine.
>
> Now maybe if we had NFS exported directories everywhere, and stuff
> cross mounted all over the place with autofs, then we might change our
> minds.  
>
> In any case, I don't dis-agree with the fundamental request to make
> the NFS client code on Linux easier to work with.  I bet Trond (who
> works at NetApp) will have something to say on this issue.

Just for the others who may be reading this thread --

If you use sufficient network bandwidth and high quality
enough networks and NFS servers with plenty of resources,
then you _may_ be able to get away with "soft" mounting
for a some period of time.

However, any server, including Solaris and NetApp servers,
will fail, and those failures may or may not affect the
NFS service being provided.  In fact, unless the system
is being carefully administrated and the applications are
written very well, with error detection and recovery in
mind, then corruption can occur, and it can be silent and
unnoticed until too late.  In fact, most failures do occur
silently and get chalked up to other causes because it will
not be possible to correlate the badness with the NFS
client giving up when attempting to communicate with an
NFS server.

I wish you the best of luck, although with the environment
that you describe, it seems like "hard" mounts would work
equally well and would not incur the risks.

       ps
