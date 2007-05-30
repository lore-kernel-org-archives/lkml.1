Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXE3HKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXE3HKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXE3HKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:10:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:49149 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751188AbXE3HKC (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:10:02 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/uYosBx/nuBmuRbGGb54ZC5bOm4yiQSLbtbI4V1k
	z/Cjd2TBt7tvj7
Date: Wed, 30 May 2007 09:10:00 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ian Kumlien <iank@bredband.net>, Linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [BUG] Something goes wrong with timer statistics.
Message-ID: <20070530071000.GB2226@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Ian Kumlien <iank@bredband.net>, Linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <1180474738.22497.25.camel@pi.pomac.com> <6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com> <1180478288.20546.39.camel@chaos> <20070530065204.GA2226@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070530065204.GA2226@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.30 08:52:04 +0200, Björn Steinbrink wrote:
> On 2007.05.30 00:38:08 +0200, Thomas Gleixner wrote:
> > On Wed, 2007-05-30 at 00:24 +0200, Michal Piotrowski wrote:
> > > Hi Ian,
> > > 
> > > (Thomas "The Wizard of Time" added to CC :))
> > 
> > Added more wizards :)
> > 
> > > On 29/05/07, Ian Kumlien <iank@bredband.net> wrote:
> > > > Hi,
> > > >
> > > > As the daystar sets, i try to play some with my new would be
> > > > firewall/server, but since this will be running for quite some time i
> > > > have been experimenting with powertop to find out what i can do to limit
> > > > it's power usage.
> > > >
> > > > But, if i run powertop for too long or a few times to many... this
> > > > happens:
> > > > http://pomac.netswarm.net/pics/kernel_panic.jpg
> > 
> > This was reported before. It's incredibly hard to reproduce.
> 
> Hm, tstats_write() only grabs show_mutex, but it calls reset_entries()
> which happily messes with the entries table, shouldn't the table_lock
> also be held in that case?

Hrmpf, nevermind, I missed the active flag...

Sorry,
Björn
