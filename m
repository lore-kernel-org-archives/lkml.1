Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYBJB13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYBJB13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 20:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYBJB1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 20:27:17 -0500
Received: from koto.vergenet.net ([210.128.90.7]:39883 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYBJB1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 20:27:15 -0500
Date: Sun, 10 Feb 2008 10:27:12 +0900
From: Simon Horman <horms@verge.net.au>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ipvs: Cleanup sync daemon code
Message-ID: <20080210012710.GC3589@verge.net.au>
References: <Pine.LNX.4.64.0802100029150.15729@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802100029150.15729@titan.stealer.net>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 12:38:11AM +0100, Sven Wegener wrote:
> Hi all,
>
> I'd like to get your feedback on this:
>
> - Use kthread_run instead of doing a double-fork via kernel_thread()
>
> - Return proper error codes to user-space on failures
>
> Currently ipvsadm --start-daemon with an invalid --mcast-interface will  
> silently suceed. With these changes we get an appropriate "No such 
> device" error.
>
> - Use wait queues for both master and backup thread
>
> Instead of doing an endless loop with sleeping for one second, we now use 
> wait queues. The master sync daemon has its own wait queue and gets woken 
> up when we have enough data to sent and also at a regular interval. The  
> backup sync daemon sits on the wait queue of the mcast socket and gets  
> woken up as soon as we have data to process.

Hi Sven,

This looks good to me, assuming that its tested and works.

A few minor things:

In sb_queue_tail() master loop is woken up if
the ip_vs_sync_count reaches 10, which seems a bit arbitary.

Perhaps its just my mail reader, but the patch seemed a bit screwy when
I saved it to a file. I this fixed the problem I was seeing using s/^  / /

Unfortuantely/Fortunately I am about to leave for a few days skiing,
so if I am quiet you will know why.

Acked-by: Simon Horman <horms@verge.net.au>

-- 
Horms

