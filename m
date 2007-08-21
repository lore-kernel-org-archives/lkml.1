Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbXHUS4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbXHUS4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760696AbXHUS4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:56:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44552 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760965AbXHUS4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:56:42 -0400
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200708211857.l7LIvfn4379558@sabah.engr.sgi.com>
Subject: Re: [PATCH] Send exit code through for taskstats.ac_exitcode
To: balbir@linux.vnet.ibm.com
Date: Tue, 21 Aug 2007 11:57:41 -0700 (PDT)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46CB2E7B.70103@linux.vnet.ibm.com> from "Balbir Singh" at Aug 21, 2007 11:57:07 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Aug 21 11:27:07 2007, balbir@linux.vnet.ibm.com wrote:
> 
> > Hi Balbir,
> > 
> > That was what I wanted to do at first, but there was some concern over
> > whether it would affect any of the intervening function calls.  If there's
> > no particular reason why the tsk->exit_code assignment is placed where it's
> > at now, then yes, I would much rather move it to before taskstats_exit().
> > 
> > I looked at the following functions involving tsk:
> > 
> >   exit_mm
> >     mm_release
> >       deactivate_mm
> >   exit_sem
> >   __exit_files
> >   __exit_fs
> >   cpuset_exit
> >   exit_keys
> > 
> > and don't see anything that setting exit_code would affect.  What do you
> > think?
> 
> I think your search and analysis leads me to believe that, it might be the
> correct thing to do. I would suggest we patch it that way and run a
> functional test like LTP to ensure we did not break anything.
> 
> What do you think?

Okay, I'll post a revised patch next.  Thanks.

Jonathan
