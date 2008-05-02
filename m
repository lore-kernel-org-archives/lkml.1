Return-Path: <linux-kernel-owner+w=401wt.eu-S937234AbYEBWry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937234AbYEBWry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbYEBWrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:47:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:55658 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbYEBWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=uDtGe1b7jnb4lKOGxuztxsPsdt6ENt+arSfRkZ98GW1OAXivnZ8FpG7uLaHcdisuEcrjWdQdsDXbSSXuGOakE7bNqSVwZJVyVhtC3DjWuQMYvXp8Ga520RAjZ6v12m1refwCt21PdLYGoNpFAhTkPQ4RX63wetFcH55uepYhfis=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][-mm] Simple stats for cpu resource controller v3
Date: Sat, 3 May 2008 04:17:03 +0530
User-Agent: KMail/1.9.9
Cc: dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, menage@google.com, balbir@in.ibm.com,
       vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl
References: <200804052339.46632.balajirrao@gmail.com> <200805030110.29511.balajirrao@gmail.com> <20080502125304.77dd38ba.akpm@linux-foundation.org>
In-Reply-To: <20080502125304.77dd38ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805030417.07794.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2008 01:23:04 am Andrew Morton wrote:
> On Sat, 3 May 2008 01:10:28 +0530
>
> Balaji Rao <balajirrao@gmail.com> wrote:
> > On Friday 02 May 2008 02:30:26 am Andrew Morton wrote:
> > <snip>
> >
> > Hi Andrew,
> >
> > Thank you for the review.
> >
> > > Did you consider using include/linux/percpu_counter.h?
> > >
> > > If so, what was wrong with it?
> > >
> > > Because it would be much better to fix per-cpu counters than to invent
> > > new stuff.
> >
> > No, I hadn't consider using the percpu_counters infrastructure. But today
> > when I tried using it, I got an early exception.I guess its because I
> > tried calling percpu_counter_init from within sched_init, which I perhaps
> > shouldn't do, because percpu_counter_init expects cpu hotplug code to be
> > initialized by then. Right ? Correct me if I'm wrong.
>
> I don't see any reason why we cannot run percpu_counter_init() prior to
> running percpu_counter_startup().  And it is desirable that we be able to
> start using the percpu-counters quite early.
>
> Can you debug it a bit please?  It's probably some silly little thing,
> perhaps fixable by calling percpu_counter_startup() earlier.
>
percpu_counter_init uses kmalloc to create percpu counters. This raises an 
early exception as kmem_cache is not initialized that early.

It worked for me if we statically allocate memory for the counters. But its 
not at all a nice thing to do and I don't see another way to make it fit for 
early use.

I'm beginning to run out of ideas! Why not do what I earlier suggested - begin 
collecting statistics once we are able to safely use percpu_counters ? This 
now seems to be the best alternative IMHO.

-- 
Warm Regards,

Balaji Rao
Dept. of Mechanical Engineering
NITK
