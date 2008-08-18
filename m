Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYHRK63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYHRK63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYHRK6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:58:21 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:20700 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751291AbYHRK6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:58:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GKLY7Q0lNICXEq3MA5vFhaN851Cp8UE9QxoE2u5NgwdZfUnu+2/Keu0zcmjX3IExDYlTm/DsX+al1NdM56/ITwBR99Rs8M9JucFiYT6clJPTi011dbg1PCHl0ihzHTg4+VJU7qNjxWQ8uG+7WbQzQfRrnrBXyUX/S+uvcHV8Pow=  ;
X-YMail-OSG: zNMyZmMVM1lM3DmkWf82UXZvh4roJgiXQsn1Dfs4P_JT_BfN3x_mH6uPLDlz1A8s5nCqFsllkRohJDhbm_TUGqSFB7Tr5yx_iLmd5MCCU278R478nHpgeCvqia4LCvGItww-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
Date: Mon, 18 Aug 2008 20:58:07 +1000
User-Agent: KMail/1.9.5
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
References: <1218880552.11912.9.camel@matrix> <200808172304.50103.nickpiggin@yahoo.com.au> <1219056601.10800.306.camel@twins>
In-Reply-To: <1219056601.10800.306.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808182058.07346.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 20:50, Peter Zijlstra wrote:
> On Sun, 2008-08-17 at 23:04 +1000, Nick Piggin wrote:
> > On Sunday 17 August 2008 00:53, Peter Zijlstra wrote:
> > > Has nothing to do with CFS, but everything to do with the fact that we
> > > now have a 95% bandwidth control by default.
> > >
> > > Does doing:
> > >
> > > echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> > >
> > > fix it?
> > >
> > > So, up to 95% cpu usage (per sched_rt_period_us) FIFO and RR behave
> > > like they always did, once they cross that line, they'll be throttled.
> > >
> > > 95% seemed like a sane default in that it leaves a little room to
> > > recover from a run-away rt process (esp handy now that !root users can
> > > also use RT scheduling classes), and should be enough for most
> > > applications as they usually don't consume all that much time.
> >
> > Did it seem sane to break POSIX and backwards compatiblity by default?
>
> Up to a point, yes.
>
> There were quite a few complaints that runaway RT tasks could render a
> machine unusable - which made 'desktop' usage of the RT class unsafe.

Right, but it is restricted to root, and if the task is run as root
then it can equally break the system in any number of ways. So the
complaints are just wrong.

I have no problems with having some non-default mode to throttle by
default. And we already have the sysrq which can downgrade RT tasks.


> This 95%/1s default allows most RT tasks to run without having to tinker
> with the settings, and for those who do need something else, they can
> get it too, but will have to turn a knob.

And that could also easily cause huge problems for code that does the
*right* thing.


> But I guess we could change the default back to unlimited and default to
> unsafe if people feel strongly about this.

Yes, you can't just break the API like this. Please do fix.
