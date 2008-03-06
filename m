Return-Path: <linux-kernel-owner+w=401wt.eu-S935143AbYCFQ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935143AbYCFQ2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934928AbYCFQ1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:27:36 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:59259 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934919AbYCFQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:27:34 -0500
Date: Thu, 6 Mar 2008 08:27:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Jike Song <albcamus@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc4 rcupreempt.h WARNINGs while suspend/resume
Message-ID: <20080306162724.GA9309@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <a8e1da0803042324ndd3873ay61cee6112d9dda9a@mail.gmail.com> <df9815e70803042335j4ea66028y96d6be21f0970aa1@mail.gmail.com> <20080305165531.GB8728@linux.vnet.ibm.com> <df9815e70803051811o4c4a42e0td56cfd32b80c66b2@mail.gmail.com> <20080306022854.GK8728@linux.vnet.ibm.com> <a8e1da0803051920t586c7fbapadda70ae895f8893@mail.gmail.com> <a8e1da0803060308o690c1545l1eaffc0c40f2bc7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0803060308o690c1545l1eaffc0c40f2bc7e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 07:08:55PM +0800, Dave Young wrote:
> On Thu, Mar 6, 2008 at 11:20 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > On Thu, Mar 6, 2008 at 10:28 AM, Paul E. McKenney
> >
> > <paulmck@linux.vnet.ibm.com> wrote:
> >  >
> >  > On Thu, Mar 06, 2008 at 10:11:26AM +0800, Jike Song wrote:
> >  >  > On Thu, Mar 6, 2008 at 12:55 AM, Paul E. McKenney
> >  >  > <paulmck@linux.vnet.ibm.com> wrote:
> >  >  > >  Could you please try applying Karsten Wiese's patch to see if it
> >  >  > >  fixes the WARNINGs?  See http://lkml.org/lkml/2008/2/26/386 for
> >  >  > >  the patch.
> >  >  > >
> >  >  > >                                                 Thanx, Paul
> >  >  >
> >  >  > Yes, the WARNING disappears with Karsten's patch applied.
> >  >  > Thanks.
> >
> >  Confirmed
> >
> >
> >
> >  >
> >  >  Good to hear!!!  I believe that Karsten's patch is on its way in,
> >  >  so hopefully that will clear things up.
> 
> Hi, paul
> 
> My syslog became a 2G size big file yestoday due to the warnings.
> How about change the WARN_ON to WARN_ON_ONCE?

Hello, Dave,

I might be convinced to make this change for 2.6.26, but the condition
that the WARN_ON() is complaining about is quite serious, so I don't
want to take a chance on it getting lost in the noise in the 2.6.25
series.

Seem reasonable?

Better yet, is there some sort of time-limited WARN_ON that kicks out
a message at most once per second or some such?  Enough to definitely
be noticed, but not enough to bring the machine to its knees?

							Thanx, Paul
