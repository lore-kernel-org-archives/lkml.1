Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYJGQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYJGQeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYJGQeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:34:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35462 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbYJGQeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:34:04 -0400
Date: Tue, 7 Oct 2008 09:34:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de
Subject: Re: RCU hang on cpu re-hotplug with 2.6.27rc8
Message-ID: <20081007163401.GJ6384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081006141220.GA14160@basil.nowhere.org> <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007154939.GN20740@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 05:49:39PM +0200, Andi Kleen wrote:
> > Hmmm...  I chased out a number of these when doing rcutree.
> > 
> > This with classic RCU or preemptable RCU?
> 
> classic.
> 
> > Could you please send me your .config file?
> 
> http://halobates.de/defconfig64

Thank you!  Hmmm, classic RCU, worked just fine in 2.6.27-rc7 with
Thomas's patch.  I was doing random onlines and offlines in a loop,
with about 3 seconds between each operation continuously for more than
ten hours, both x86 and Power.  So could you please try 2.6.27-rc7 with
Thomas's patch as follows?

http://www.rdrop.com/users/paulmck/patches/2.6.27-rc7-tglx-timer-1.patch

Failing that, I guess my next step would be to create tracing for
classic RCU to help figure out what RCU believes is preventing the
grace period from ending.

						Thanx, Paul
