Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbZKJUap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbZKJUap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758091AbZKJUap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:30:45 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:51905 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092AbZKJUao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:30:44 -0500
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 15:30:44 EST
Date: Tue, 10 Nov 2009 15:20:41 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Minchan Kim <minchan.kim@gmail.com>
cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter
  instead
In-Reply-To: <28c262360911062019q254f7541lbdc3d94491a69bd6@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0911101519250.14300@V090114053VZO-1>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1>  <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1>  <28c262360911060741x3f7ab0a2k15be645e287e05ac@mail.gmail.com>  <alpine.DEB.1.10.0911061209520.5187@V090114053VZO-1>
 <28c262360911062019q254f7541lbdc3d94491a69bd6@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Nov 2009, Minchan Kim wrote:

> On Sat, Nov 7, 2009 at 2:10 AM, Christoph Lameter
> <cl@linux-foundation.org> wrote:
> > On Sat, 7 Nov 2009, Minchan Kim wrote:
> >
> >> How about change from 'mm_readers' to 'is_readers' to improve your
> >> goal 'scalibility'?
> >
> > Good idea. Thanks. Next rev will use your suggestion.
> >
> > Any creative thoughts on what to do about the 1 millisecond wait period?
> >
>
> Hmm,
> it would be importatn to prevent livelock for reader to hold lock
> continuously before
> hodling writer than 1 msec write ovhead.

Livelock because there are too frequent readers?

We could just keep the mutex locked to ensure that no new readers arrive.

> First of all, After we solve it, second step is that optimize write
> overhead, I think.

