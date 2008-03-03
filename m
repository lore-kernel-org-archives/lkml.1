Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbYCCKNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbYCCKNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbYCCKM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:12:56 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:39817 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbYCCKMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pbWz225ValX3S67Nc08cgHnm3RMTBaCu9Hf8mnu6f1OIrvr3C+k+j5qqQFNdlCTUxUO1FVSFnixa/Otsee57XXwnQ71UvotZZ2FDtKzWlCuCNKYceEKAPMH20GaTx5Qq/WF2HWTDymOIBgejVs8m7/RGIctCSP3kDJk2Gz+5aBE=
Message-ID: <cfd18e0f0803030212l3783567ek6ca058889873dfac@mail.gmail.com>
Date: Mon, 3 Mar 2008 11:12:52 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: SCHED_IDLE documentation
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Christoph Hellwig" <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, "Jeremy Kerr" <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080303100418.GF18281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203376368.275756.252634247263.1.gpush@pokey>
	 <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
	 <20080303092422.GA18281@elte.hu> <200803031031.52335.arnd@arndb.de>
	 <20080303100418.GF18281@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 11:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Arnd Bergmann <arnd@arndb.de> wrote:
>
> > On Monday 03 March 2008, Ingo Molnar wrote:
> > > > * What's the difference between SCHED_IDLE and SCHED_BATCH?
> > >
> > > SCHED_BATCH can still have nice levels from -20 to +19, it is a modified
> > > SCHED_OTHER/SCHED_NORMAL for "throughput oriented" workloads.
> > >
> > > SCHED_IDLE overrides the nice settings and it means a "super idle"
> > > workload.
> >
> > Does that mean that a SCHED_IDLE task still runs some of the time if
> > you have a CPU hog running on +19, or can any other process starve the
> > SCHED_IDLE task?
>
> yes, even SCHED_IDLE tasks get some CPU time - so complete starvation
> should not be possible. We dont really want to define the exact amount
> of time they need. (we might want to change that in the future) But it
> will always be less prio than nice +19 :-) You can think of it as if it
> was "nice +30".
>
> > What happens if you have two SCHED_IDLE tasks on a single CPU, do they
> > get equal share, or will they just run as batch jobs?
>
> they get equal share.
>
> you can try it out too: if you have 2.6.23 or newer kernels then just
> pick up schedtool and use "schedtool -I" to run SCHED_IDLE tasks.

Thanks for the answers Ingo!

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
