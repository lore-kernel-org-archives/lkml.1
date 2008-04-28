Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbYD1Jdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbYD1Jdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762508AbYD1JdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:33:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932961AbYD1JdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:33:21 -0400
Date: Mon, 28 Apr 2008 02:31:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-Id: <20080428023139.fe318427.akpm@linux-foundation.org>
In-Reply-To: <20080428091745.GB27056@osiris.boeblingen.de.ibm.com>
References: <20080427211224.GA21830@osiris.boeblingen.de.ibm.com>
	<20080427183926.acb66fff.akpm@linux-foundation.org>
	<20080428070946.GA4507@osiris.boeblingen.de.ibm.com>
	<20080428002853.1693e7fd.akpm@linux-foundation.org>
	<20080428075253.GB4507@osiris.boeblingen.de.ibm.com>
	<20080428081129.GC4507@osiris.boeblingen.de.ibm.com>
	<20080428083222.GA16963@elte.hu>
	<20080428084904.GA27056@osiris.boeblingen.de.ibm.com>
	<20080428015723.e1632c45.akpm@linux-foundation.org>
	<20080428091745.GB27056@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 11:17:45 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Apr 28, 2008 at 01:57:23AM -0700, Andrew Morton wrote:
> > On Mon, 28 Apr 2008 10:49:04 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > >  /* doms_cur_mutex serializes access to doms_cur[] array */
> > > -static DEFINE_MUTEX(doms_cur_mutex);
> > > +static DEFINE_MUTEX(sched_domains_mutex);
> > 
> > The comment refers to a no-longer-existing lock, and no longer correctly
> > describes the lock's usage.
> 
> version 42. Please feel free to change the comment if you think it could
> be better :)

Actually, it's a pretty bad comment ;)

> +/* sched_domains_mutex serializes calls to arch_init_sched_domains,
> + * detach_destroy_domains and partition_sched_domains.
> + */

locks protect *data*, not "calls".  This matters.  Which data is actually
protected by this lock??

