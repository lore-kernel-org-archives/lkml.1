Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbXJQG3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbXJQG3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXJQG3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:29:32 -0400
Received: from ozlabs.org ([203.10.76.45]:50395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbXJQG3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:29:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH 1/4] Refcount Based Cpu-Hotplug Implementation
Date: Wed, 17 Oct 2007 16:29:12 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
References: <20071016103308.GA9907@in.ibm.com> <200710171047.42693.rusty@rustcorp.com.au> <20071017053754.GB9940@in.ibm.com>
In-Reply-To: <20071017053754.GB9940@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710171629.13060.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2007 15:37:54 Gautham R Shenoy wrote:
> On Wed, Oct 17, 2007 at 10:47:41AM +1000, Rusty Russell wrote:
> > On Tuesday 16 October 2007 20:34:17 Gautham R Shenoy wrote:
> > > This patch implements a Refcount + Waitqueue based model for
> > > cpu-hotplug.
> >
> > Hi Gautham,
>
> Hi Rusty,
>
> > 	I can't see where you re-initialize the completion.
>
> The cpu_hotplug.readers_done is a global variable which has been
> initialized in cpu_hotplug_init.
>
> So I am wondering is the re-initialization required ?

Yes.  AFAICT you use this completion on every hotplug.  Yet once a completion 
is completed, it needs to be re-initialized to be reused: it's "complete" and 
wait_for_completion will return immediately thereafter.

Perhaps you want a waitqueue instead?

Rusty.
