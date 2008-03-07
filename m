Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYCGHbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYCGHbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYCGHbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:31:08 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:63561 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYCGHbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:31:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mGalW/b2WHiwDctnq8uiE0jpjT2bYT3IFSU+/v0trE98726AuKO4i+x5SW7PQ2tzD97Np7/zFE1xea5Dp7oPA9I2RSN/VTquilIze7jYO2xvRLWZlOX1910SWlpiuZdQwobM0zCr2w9vf1eDw5L3nprLuxychzTgQiJzS4PE3bg=
Message-ID: <a8e1da0803062331la1f38fei8303a46f9949ca23@mail.gmail.com>
Date: Fri, 7 Mar 2008 15:31:05 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: 2.6.25-rc4 rcupreempt.h WARNINGs while suspend/resume
Cc: "Jike Song" <albcamus@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080307065752.GF19183@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <df9815e70803042335j4ea66028y96d6be21f0970aa1@mail.gmail.com>
	 <df9815e70803051811o4c4a42e0td56cfd32b80c66b2@mail.gmail.com>
	 <20080306022854.GK8728@linux.vnet.ibm.com>
	 <a8e1da0803051920t586c7fbapadda70ae895f8893@mail.gmail.com>
	 <a8e1da0803060308o690c1545l1eaffc0c40f2bc7e@mail.gmail.com>
	 <20080306162724.GA9309@linux.vnet.ibm.com>
	 <a8e1da0803061907k72785f10t2dcb98ca9829e2d8@mail.gmail.com>
	 <20080307041940.GB19183@linux.vnet.ibm.com>
	 <a8e1da0803062035o318bd843o22b561faa52fd19f@mail.gmail.com>
	 <20080307065752.GF19183@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2008 at 2:57 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> On Fri, Mar 07, 2008 at 12:35:26PM +0800, Dave Young wrote:
>  > On Fri, Mar 7, 2008 at 12:19 PM, Paul E. McKenney
>  > <paulmck@linux.vnet.ibm.com> wrote:
>  > > On Fri, Mar 07, 2008 at 11:07:48AM +0800, Dave Young wrote:
>  > >  > On Fri, Mar 7, 2008 at 12:27 AM, Paul E. McKenney
>  > >  > <paulmck@linux.vnet.ibm.com> wrote:
>  > >  > > On Thu, Mar 06, 2008 at 07:08:55PM +0800, Dave Young wrote:
>  > >
>  > > > >  > My syslog became a 2G size big file yestoday due to the warnings.
>  > >  > >  > How about change the WARN_ON to WARN_ON_ONCE?
>  > >  > >
>  > >  > >  Hello, Dave,
>  > >  > >
>  > >  > >  I might be convinced to make this change for 2.6.26, but the condition
>  > >  > >  that the WARN_ON() is complaining about is quite serious, so I don't
>  > >  > >  want to take a chance on it getting lost in the noise in the 2.6.25
>  > >  > >  series.
>  > >  > >
>  > >  > >  Seem reasonable?
>  > >  >
>  > >  > IMHO, WARN_ON_ONCE is enough for my eyes :)
>  > >
>  > >  I could believe that, but my experience has been that many others
>  > >  need the condition to be obvious...
>  > >
>  > >
>  > >  > >  Better yet, is there some sort of time-limited WARN_ON that kicks out
>  > >  > >  a message at most once per second or some such?  Enough to definitely
>  > >  > >  be noticed, but not enough to bring the machine to its knees?
>  > >  >
>  > >  > Seems there's no such functions/macros, but is is really needed?
>  > >
>  > >  If everyone reports errors when they see isolated WARN_ON()s in their
>  > >  logfiles, then no.  But...
>  >
>  > Ok, I agree with you.
>  >
>  > Maybe something like WARN_ON_HZ(condition) or
>  > WARN_ON_PERIOD(condition, period_value)?
>
>  Makes sense to me!  The other benefit of this sort of thing is that
>  it lets you know whether the problem was a one-off or whether it
>  continued happening -- but without too much log bloat.
>
>  I was thinking in terms of once every ten seconds, but am not all
>  that hung up on the exact value of the period.
>
>  Thoughts?

Then, WARN_ON_SECS(condition, seconds) ?

>
>                                                 Thanx, Paul
>
