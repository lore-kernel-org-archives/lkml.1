Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZHaOai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZHaOai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZHaOah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:30:37 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54738 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZHaOah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:30:37 -0400
Date: Mon, 31 Aug 2009 07:30:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, manfred@colorfullife.com,
       Ihno Krumreich <ihno@suse.de>, Greg KH <gregkh@suse.de>
Subject: Re: [BUG] race of RCU vs NOHU
Message-ID: <20090831143036.GA6800@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090807142957.GB6700@linux.vnet.ibm.com> <20090810142535.3e685109@skybase> <20090810150807.GA6791@linux.vnet.ibm.com> <20090811125653.12c35ee8@skybase> <20090811145222.GA6739@linux.vnet.ibm.com> <20090811171751.34ca3b3b@skybase> <20090811180407.GD6739@linux.vnet.ibm.com> <20090812093233.4006b9a1@skybase> <20090821155418.GB6735@linux.vnet.ibm.com> <20090831104728.1b439a54@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831104728.1b439a54@skybase>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 10:47:28AM +0200, Martin Schwidefsky wrote:
> On Fri, 21 Aug 2009 08:54:18 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Aug 12, 2009 at 09:32:33AM +0200, Martin Schwidefsky wrote:
> > > On Tue, 11 Aug 2009 11:04:07 -0700
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > > On Tue, Aug 11, 2009 at 05:17:51PM +0200, Martin Schwidefsky wrote:
> > > > > On Tue, 11 Aug 2009 07:52:22 -0700

[ . . . ]

> > > > > We found the bug with kernel version 2.6.30 - the kernel on our test systems
> > > > > still use classic RCU. For us it is easy to switch to tree-RCU, no patch
> > > > > required.
> > > > 
> > > > Ah!  Could you please send me the test you use?  My tests were
> > > > insufficient to force this problem to happen.
> > > 
> > > There is no specific test, just a regular system boot. The boot did not
> > > finish and our tester took a dump. This boot failure seems to happen from
> > > time to time.
> > 
> > OK.  Has CONFIG_TREE_RCU been working for you?  If so, which variant
> > of 2.6.27 do you need a backport to?
> 
> We changed the configuration of our test kernels to CONFIG_TREE_RCU. So
> far the problem has not shown up again. As we a dealing with a rare race
> here this has to be taken with a grain of salt.

Thank you for trying it out!

Did you by any chance record the success and failure statistic?  Perhaps
something like number of failures per unit time, time to first failure,
number of successful vs. failed reboots, or whatever?  This would allow
calculation of confidence statistics.

							Thanx, Paul
