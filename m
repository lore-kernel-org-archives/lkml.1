Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZFKTL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZFKTL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZFKTLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:11:52 -0400
Received: from thunk.org ([69.25.196.29]:42745 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbZFKTLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:11:52 -0400
Date: Thu, 11 Jun 2009 15:11:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IO latency - a special case
Message-ID: <20090611191152.GD16787@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Trenton D. Adams" <trenton.d.adams@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com> <9b1675090904041131u28635d8dnc3d13e88000394b4@mail.gmail.com> <20090405011355.GE7553@mit.edu> <9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com> <9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com> <9b1675090904042313rb8178b6v1da3aeddfa57a869@mail.gmail.com> <20090405062626.GA7760@mit.edu> <9b1675090904051542o42a0ca11y1ce3b691ed6d8ebb@mail.gmail.com> <9b1675090906062014h2ce44d8apc50f73aa036d9139@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b1675090906062014h2ce44d8apc50f73aa036d9139@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 09:14:43PM -0600, Trenton D. Adams wrote:
> I'm back into doing some Java development, and it's happening again.
> I'm running 2.6.30-rc7, and I did a SysReq+T, I hope this is helpful.
> I've attached a txt.gz file, because it's 367K to my
> /var/log/messages.
> 
> The important stuff, I believe, is the Java related stuff.  As a quick
> refresher to this problem, it appears to be related to how my Java IDE
> saves the file, and perhaps something doesn't release the futex right
> away?

Have you checked your memory usage via SysReq-m, or /proc/meminfo or
simply using "free".  I'm seeing a lot of processes in do_page_fault,
which is interesting, especially in the non-Java processes.  

Back in April, your vmstat output didn't show much swapping activity,
but maybe there was more paging activity that didn't show up there?   

> I've also seen these symptoms previously...
> 
> 1. Problem arises, I Ctrl-C the process when I notice the system
> getting really sluggish.
> 2. Start process again, and it locks up the machine for about an hour

What sort of process where you typicalling trying to kill using ^C?

     	     	     	       		   	  - Ted
