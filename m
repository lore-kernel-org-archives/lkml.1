Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbZD1Va6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbZD1Va6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZD1Vas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:30:48 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:53976 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZD1Var (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:30:47 -0400
Date: Tue, 28 Apr 2009 17:21:29 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
In-Reply-To: <1240953796.7620.160.camel@twins>
Message-ID: <alpine.DEB.1.10.0904281719480.15947@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>  <1239951613.23397.4107.camel@laptop>  <alpine.DEB.1.10.0904170941020.11877@qirst.com>  <1239977776.23397.4590.camel@laptop>  <alpine.DEB.1.10.0904171021360.20239@qirst.com>  <1239979901.23397.4638.camel@laptop>
  <alpine.DEB.1.10.0904171100510.21575@qirst.com>  <1239982137.23397.4684.camel@laptop> <20090423044228.GA2428@ucw.cz>  <alpine.DEB.1.10.0904281700220.15947@qirst.com> <1240953796.7620.160.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Peter Zijlstra wrote:

> On Tue, 2009-04-28 at 17:02 -0400, Christoph Lameter wrote:
> > On Thu, 23 Apr 2009, Pavel Machek wrote:
> >
> > > I'd say that taking interrupt and returning in below 1000nsec is
> > > impossible, even on very fast hw.
> >
> > Hmmm.... Could it be that CONFIG_NO_HZ caused the timer interrupt to be
> > avoided in earlier releases? NO_HZ theory at least is to only schedule
> > interrupts when  necessary. So an interrupt is needed at the end of the
> > scheduling intervals and not at HZ frequency.
>
> No, NOHZ only works on idle cpus.

It is advertised to do more:

config NO_HZ
        bool "Tickless System (Dynamic Ticks)"
        depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
        select TICK_ONESHOT
        help
          This option enables a tickless system: timer interrupts will
          only trigger on an as-needed basis both when the system is
          busy and when the system is idle.


So NO_HZ is really IDLE_NO_HZ. The system is not tickless.


