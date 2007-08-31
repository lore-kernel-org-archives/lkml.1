Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXHaIG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXHaIG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 04:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXHaIGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 04:06:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47543 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbXHaIGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 04:06:42 -0400
X-Sasl-enc: 85Ve2jNnET45HJMwXCPE+D1WV4kPZd1YRCS9H+wcr2az 1188547601
Date: Fri, 31 Aug 2007 16:06:36 +0800 (WST)
From: Ian Kent <raven@themaw.net>
To: John Stoffel <john@stoffel.org>
cc: Peter Staubach <staubach@redhat.com>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
In-Reply-To: <18123.13314.43009.263383@stoffel.org>
Message-ID: <Pine.LNX.4.64.0708311600120.12745@raven.themaw.net>
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org>
 <46CB1A78.7040102@redhat.com> <18123.13314.43009.263383@stoffel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, John Stoffel wrote:

> >>>>> "Peter" == Peter Staubach <staubach@redhat.com> writes:
> 
> Peter> John Stoffel wrote:
> Robin> I'm bringing this up again (I know it's been mentioned here
> Robin> before) because I had been told that NFS support had gotten
> Robin> better in Linux recently, so I have been (for my $dayjob)
> Robin> testing the behaviour of NFS (autofs NFS, specifically) under
> Robin> Linux with hard,intr and using iptables to simulate a hang.
> >> 
> >> So why are you mouting with hard,intr semantics?  At my current
> >> SysAdmin job, we mount everything (solaris included) with 'soft,intr'
> >> and it works well.  If an NFS server goes down, clients don't hang for
> >> large periods of time. 
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

So, there's a power outage and the UPS had a glitch.
Oops, you've got to recover multiple TB and tell users everything since 
the last incremental backup is gone.

You use UPS in the computer room but management, in it's cost cutting 
wisdom, hasn't provided for UPS for your Unix workstations and there's a 
power outage. Oops, you've got lots of corrupt files but you don't know 
which ones they are so you've got to recover multiple TB and tell users 
everything since the last incremental backup is gone.

Ok, so hard mounting may not always save you in these circumstances but 
soft mounting will surely get you in the neck.

Ian

