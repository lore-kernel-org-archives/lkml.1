Return-Path: <linux-kernel-owner+w=401wt.eu-S964812AbXBEWHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbXBEWHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964830AbXBEWHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:07:47 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:53776 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812AbXBEWHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:07:46 -0500
Date: Mon, 5 Feb 2007 23:07:45 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070205220745.GB32115@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Davide Libenzi <davidel@xmailserver.org>,
	Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com> <20070205213618.GA30923@outpost.ds9a.nl> <Pine.LNX.4.64.0702051350010.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702051350010.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 01:57:15PM -0800, Linus Torvalds wrote:

> I doubt very many people want to do that. It would tend to simply be nicer 
> to do
> 
> 	async(poll);

Yeah - I saw that technique being mentioned later on in the thread, and it
would work, I think.

To make up for the waste of time, some other news. I asked Matt Dillon of
DragonflyBSD why he removed asynchronous system calls from his OS, and he
told me it was because of the problems he had implementing them in the
kernel:

    There were two basic problems:  First, it added a lot of overhead when
    most system calls are either non-blocking anyway (like getpid()). 
    Second and more importantly it was very, very difficult to recode the
    system calls that COULD block to actually be asynchronous in the kernel. 
    I spent some time recoding nanosleep() to operate asynchronously and it
    was a huge mess.

Aside from that, they did not discover any skeletons hidden in the closet,
although from mailing list traffic, I gather the asynchronous system calls
didn't see a lot of use. If I understand it correctly, for a number of years
they emulated asynchronous system calls using threads.

We'd be sidestepping the need to update all syscalls via 'fibrils' of
course.

> If you think of it in those terms, it all makes sense *without* any file 
> descriptors what-so-ever, and the "wait_for_async()" interface also makes 
> a ton of sense (it really *is* "waitpid()" for the system call).

It has me excited in any case. Once anything even remotely testable appears
(Zach tells me not to try the current code), I'll work it into MTasker
(http://ds9a.nl/mtasker) and make it power a nameserver that does async i/o,
for use with very very large zones that aren't preloaded.

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
