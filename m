Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbXHURTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbXHURTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbXHURTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:19:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759473AbXHURTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:19:07 -0400
Message-ID: <46CB1E7B.7050700@redhat.com>
Date: Tue, 21 Aug 2007 13:18:51 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: Robin Lee Powell <rlpowell@digitalkingdom.org>
CC: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com> <20070821171423.GQ3956@digitalkingdom.org>
In-Reply-To: <20070821171423.GQ3956@digitalkingdom.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Lee Powell wrote:
> On Tue, Aug 21, 2007 at 01:01:44PM -0400, Peter Staubach wrote:
>   
>> John Stoffel wrote:
>>     
>>> Robin> I'm bringing this up again (I know it's been mentioned here
>>> Robin> before) because I had been told that NFS support had gotten
>>> Robin> better in Linux recently, so I have been (for my $dayjob)
>>> Robin> testing the behaviour of NFS (autofs NFS, specifically) under
>>> Robin> Linux with hard,intr and using iptables to simulate a hang.
>>>
>>> So why are you mouting with hard,intr semantics?  At my current
>>> SysAdmin job, we mount everything (solaris included) with
>>> 'soft,intr' and it works well.  If an NFS server goes down,
>>> clients don't hang for large periods of time. 
>>>       
>> Wow!  That's _really_ a bad idea.  NFS READ operations which
>> timeout can lead to executables which mysteriously fail, file
>> corruption, etc.  NFS WRITE operations which fail may or may not
>> lead to file corruption.
>>
>> Anything writable should _always_ be mounted "hard" for safety
>> purposes.  Readonly mounted file systems _may_ be mounted "soft",
>> depending upon what is located on them.
>>     
>
> Does write + tcp make this any different?

Nope...

TCP may make a difference if the problem is related to the network
being slow or lossy, but will not affect anything if the server
is just slow or down.  Even if TCP would have eventually gotten
all of the packets in a request or response through, the client
may time out, cease waiting, and corruption may occur again.

       ps
