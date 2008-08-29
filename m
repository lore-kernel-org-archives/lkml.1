Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYH2Jrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYH2Jrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbYH2Jrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:47:33 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:59465 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbYH2Jrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:47:32 -0400
Message-ID: <48B7C55B.4090609@fr.ibm.com>
Date: Fri, 29 Aug 2008 11:46:03 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [patch -mm 0/4] mqueue namespace
References: <20071128163728.177495768@fr.ibm.com> <m11w2syfmk.fsf@frodo.ebiederm.org> <m1ve04vkov.fsf@frodo.ebiederm.org>
In-Reply-To: <m1ve04vkov.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
> 
>> One way to fix that is to add a hidden directory to the mnt namespace.
>> Where magic in kernel filesystems can be mounted.  Only visible
>> with a magic openat flag.  Then:
>>
>> fd = openat(AT_FDKERN, ".", O_DIRECTORY)
>> fchdir(fd);
>> umount("./mqueue", MNT_DETACH);
>> mount(("none", "./mqueue", "mqueue", 0, NULL);
>>
>> Would unshare the mqueue namespace.
>>
>> Implemented for plan9 this would solve a problem of how do you get
>> access to all of it's special filesystems.  As only bind mounts
>> and remote filesystem mounts are available.  For linux thinking about
>> it might shake the conversation up a bit.
> 
> Thinking about this some more.  What is especially attractive if we do
> all namespaces this way is that it solves two lurking problems.
> 1) How do you keep a namespace around without a process in it.
> 2) How do you enter a container.
> 
> If we could land the namespaces in the filesystem we could easily
> persist them past the point where a process is present in one if we so
> choose.
>
> Entering a container would be a matter of replacing your current
> namespaces mounts with namespace mounts take from the filesystem.
> 
> I expect performance would degrade in practice, but it is tempting
> to implement it and run a benchmark and see if we can measure anything.

http://wiki.openvz.org/Containers/Mini-summit_2008_notes

you seem to have talked about this idea at the summit but the notes
are a bit short on the "entering a container" topic. Have you had time to
work on the POC the notes are talking about ? 

the mqueue namespace (and sysv ipc) is typically one of these namespaces
with valid objects which can have no processes in it. 

C. 
