Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbXFTRfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbXFTRfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757735AbXFTRfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:35:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbXFTRfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:35:09 -0400
Message-ID: <467964F6.6040700@redhat.com>
Date: Wed, 20 Jun 2007 13:33:42 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bryan Henderson <hbryan@us.ibm.com>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>, akpm@linux-foundation.org,
       alan <alan@clueserver.org>, hpa@zytor.com,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <OF1BE97403.60074CE1-ON88257300.005C4F4A-88257300.005DC171@us.ibm.com>
In-Reply-To: <OF1BE97403.60074CE1-ON88257300.005C4F4A-88257300.005DC171@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Henderson wrote:
>> The directory is quite visible with a standard 'ls -a'. Instead,
>> they simply mark it as a separate volume/filesystem: i.e. the fsid
>> differs when you call stat(). The whole thing ends up acting rather like
>> our bind mounts.
> 
> Hmm.  So it breaks user space quite a bit.  By break, I mean uses that 
> work with more conventional filesystems stop working if you switch to 
> NetAp.  Most programs that operate on directory trees willingly cross 
> filesystems, right?  Even ones that give you an option, such as GNU cp, 
> don't by default.
> 
> But if the implementation is, as described, wildly successful, that means 
> users are willing to tolerate this level of breakage, so it could be used 
> for versioning too.
> 
> But I think I'd rather see a truly hidden directory for this (visible only 
> when looked up explicitly).

Well, if we're going to have super-secret hidden directories, we might as well 
implement them in a namespace framework.  Somebody is going to want generic 
filesystem namespaces eventually, so having one unified mechanism for doing this 
kind of thing will make it much easier, especially for userspace apps which 
would need to be modified to be aware of them.

Personally, I'm happy with .snapshot and the like.

	-- Chris
