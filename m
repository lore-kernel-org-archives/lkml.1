Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYA0S7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYA0S7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYA0S6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:58:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:52971 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753583AbYA0S6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:58:52 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ooE0LHHIorEvTSQl3qJoAqR8KBa67ZbuNdUM6ov
	Mt9bXZzXPbBgmU
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
From: Mike Galbraith <efault@gmx.de>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200801271339.14668.toralf.foerster@gmx.de>
References: <479B69D2.5050603@wpkg.org>
	 <200801271200.04971.toralf.foerster@gmx.de>
	 <1201433167.22060.10.camel@homer.simson.net>
	 <200801271339.14668.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=utf-8
Date: Sun, 27 Jan 2008 19:58:48 +0100
Message-Id: <1201460328.5092.95.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-27 at 13:39 +0100, Toralf Förster wrote:
> Am Sonntag, 27. Januar 2008 schrieben Sie:
> > 
> > On Sun, 2008-01-27 at 12:00 +0100, Toralf Förster wrote:
> > > BTW the dnetc process runs under the user "dnetc" with nice level -19,
> > > my process runs under my own user id "tfoerste" therefore I wouldn't expect
> > > that both processes got the same processor resources isn't it ? :
> > 
> > Normal.  Nice level controls cpu distribution _within_ a task group,
> > whereas distribution between groups is controlled by cpu_share.  It's
> > going to take a while for folks to get used to having two levels of cpu
> > distribution.
> 
> Ough, does this mean that for a multi-user scenario of 2 non-root users "A" and
> "B" each running exactly 1 process with nice level 0 and 19 rerspectively
> that both share ~50% of the CPU *and furthermore* that that user "B" does never
> ever have a  chance to be nice to user "A" although his process should really
> use only those CPU cycles not eated by any other user ?

Yes.  If you want one task group to receive less cpu cycles, you have to
'nice' that task group by reducing it's share.
   
> If the answer is yes what's about extending the current behaviour to consider
> (optionally) nice level of running processes in the case where
> CONFIG_FAIR_GROUP_SCHED is set ?

I think it's better to just disable fair group scheduling if it doesn't
suit your needs.  It's not going to be everyone's cup of tea.

	-Mike

