Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbXBJKrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbXBJKrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 05:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXBJKrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 05:47:15 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:58160 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbXBJKrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 05:47:14 -0500
Date: Sat, 10 Feb 2007 11:47:12 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Message-ID: <20070210104712.GA20878@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Zach Brown <zach.brown@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 02:33:01PM -0800, Linus Torvalds wrote:

>  - IF the system call blocks, we call the architecture-specific 
>    "schedule_async()" function before we even get any scheduler locks, and 
>    it can just do a fork() at that time, and let the *child* return to the 
>    original user space. The process that already started doing the system 
>    call will just continue to do the system call.

Ah - cool. The average time we have to wait is probably far greater than the
fork overhead, microseconds versus milliseconds. 

However, and there probably is a good reason for this, why isn't it possible
to do it the other way around, and have the *child* do the work and the
original return to userspace?

Would confuse me at lot less in any case.

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
