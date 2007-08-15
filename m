Return-Path: <linux-kernel-owner+w=401wt.eu-S1764951AbXHOSe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764951AbXHOSe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbXHOSeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:34:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbXHOSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:34:17 -0400
Date: Wed, 15 Aug 2007 11:33:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Paul Jackson <pj@sgi.com>,
       clameter@sgi.com, dhaval@linux.vnet.ibm.com, bob.picco@hp.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       balbir@in.ibm.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, ckrm-tech@lists.sourceforge.net
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
Message-Id: <20070815113308.b3e16cc7.akpm@linux-foundation.org>
In-Reply-To: <1187200830.5422.39.camel@localhost>
References: <1187103831.6281.24.camel@localhost>
	<20070814180339.GA32553@vino.hallyn.com>
	<1187115224.6281.40.camel@localhost>
	<20070814192306.GB32553@vino.hallyn.com>
	<20070814204951.GA2065@vino.hallyn.com>
	<Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
	<1187127685.6281.139.camel@localhost>
	<Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
	<1187185392.5422.13.camel@localhost>
	<20070815092954.bfe7e86d.pj@sgi.com>
	<20070815171210.GB13286@vino.hallyn.com>
	<1187200830.5422.39.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007 14:00:29 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Wed, 2007-08-15 at 12:12 -0500, Serge E. Hallyn wrote:
> > Quoting Paul Jackson (pj@sgi.com):
> > > Lee wrote:
> > > > [altho' methinks CPUSET should select CONTAINERS rather than
> > > > depend on it...]
> > > 
> > > Good point -- what do you think, Paul Menage?
> > 
> > Paul mentioned (http://www.spinics.net/lists/linux-containers/msg03775.html)
> > that he was asked not to use select in Kconfigs any more.
> 
> That is unfortunate.  I view CPUSET is a "first class" option that
> happens to be built on CONTAINERS.  IMO, I shouldn't have to know this
> implementation detail in order to select CPUSET--indeed, even to be
> offered the optio--in 'make *config'.  However, it will be hidden if I
> haven't already selected containers.  Or do I misunderstand the
> implications of "depends on"?
> 
> Andrew:  is the problem with select something fatal or just too
> difficult to fix?
> 

I don't recall what specifically went wrong when we were using select
in there, but it was pretty ugly.

We're hitting more and more problems with this "select is
broken"-versus-"depends-on user inferface sucks" problem.  I do think that
a suitable fix could be found at the user interface level: show the
"cpusets" option to the user, but don't let them select it.  Instead, tell
the user what needs to be enabled so they can access this option.

But I haven't seen the slightest sign of anyone thinking about doing
anything along those lines.

