Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZA0Pm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZA0Pm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZA0PmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:42:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbZA0PmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:42:19 -0500
Date: Tue, 27 Jan 2009 07:41:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export get_task_comm()
In-Reply-To: <20090126211655.c7287768.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0901270739050.3123@localhost.localdomain>
References: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <AuEeLWHZjFB@christoph> <20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090126211655.c7287768.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Jan 2009, Andrew Morton wrote:
> > 
> > task::comm is good debugging information and driver developer want to
> > use this information easily.
> 
> Ho hum, I suppose so.  I redid the changelog a bit:
> 
>    task_struct.comm[] is useful for debugging and driver developers
>    want to use this information easily.  Direct access to
>    task_struct.comm[] is a bit racy, so export the official accessor.

The biggest issue I have with this is that the whole "get_task_comm()" 
interface is not very good for random users - it inherently depends on the 
result buffer being at least sizeof(tsk->comm).

If we export it to random routines, I get the feeling that we should pass 
in the size of the result buffer, so that they don't have to know about 
this requirement.

		Linus
