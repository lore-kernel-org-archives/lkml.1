Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZF1VTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZF1VTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZF1VTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:19:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755884AbZF1VTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:19:05 -0400
Date: Sun, 28 Jun 2009 14:18:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using
 pipes in core_pattern
Message-Id: <20090628141829.d3c34ad3.akpm@linux-foundation.org>
In-Reply-To: <20090628210054.GB6760@one.firstfloor.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	<20090625163050.d6a71a13.akpm@linux-foundation.org>
	<20090626104804.GA7337@hmsreliant.think-freely.org>
	<20090626092001.32e35e17.akpm@linux-foundation.org>
	<20090628193112.GA6760@one.firstfloor.org>
	<20090628135235.10f9b153.akpm@linux-foundation.org>
	<20090628210054.GB6760@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 23:00:54 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> > 
> > When was the last time we saw a "warning: process `%s' used the
> > obsolete bdflush system call" warning?  A quick google here says 2004. 
> > Is that data?  A bit, I guess.
> 
> bdflush? 

I don't understand your answer.

Many years ago (guess: 2001/2002) the bdflush() syscall was deprecated
and we did

	if (msg_count < 5) {
		msg_count++;
		printk(KERN_INFO
			"warning: process `%s' used the obsolete bdflush"
			" system call\n", current->comm);
		printk(KERN_INFO "Fix your initscripts?\n");
	}

to encourage people to stop using it.  A brief search indicates that
nobody has reported this message in 4-5 years.

So to answer the question "how long must we leave things in place before
removing them?", that's the only data I am aware of.

