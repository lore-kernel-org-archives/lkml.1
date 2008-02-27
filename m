Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbYB0APs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbYB0APs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbYB0APf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:15:35 -0500
Received: from mail.crca.org.au ([67.207.131.56]:60120 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818AbYB0APd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:15:33 -0500
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 19:15:33 EST
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
From: Nigel Cunningham <ncunningham@crca.org.au>
Reply-To: ncunningham@crca.org.au
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jiri Kosina <jkosina@suse.cz>, Chris Holvenstot <cholvenstot@comcast.net>,
       elendil@planet.nl, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080226220407.GY1287@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
	 <1203163503.6124.5.camel@popeye>
	 <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz>
	 <1203221372.6124.29.camel@popeye>
	 <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz>
	 <1203587101.27355.4.camel@popeye>
	 <20080226145832.GA1289@csclub.uwaterloo.ca>
	 <Pine.LNX.4.64.0802261602030.30955@jikos.suse.cz>
	 <20080226215812.GX1287@csclub.uwaterloo.ca>
	 <Pine.LNX.4.64.0802262300000.30955@jikos.suse.cz>
	 <20080226220407.GY1287@csclub.uwaterloo.ca>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Wed, 27 Feb 2008 11:08:05 +1100
Message-Id: <1204070885.30875.37.camel@laptop.nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2008-02-26 at 17:04 -0500, Lennart Sorensen wrote:
> On Tue, Feb 26, 2008 at 11:01:55PM +0100, Jiri Kosina wrote:
> > OK, so what very probably happened is that CONFIG_GROUP_SCHED somehow 
> > schedules X server in a way which confuses its sense of time, and 
> > therefore makes autorepeat buggy ... ?
> 
> Well in my case this has been happening quite a long time, and I am
> currently running 2.6.22 from Debian and I don't see any such config
> option in the config.
> 
> $ grep SCHED /boot/config-2.6.22-3-k7
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> CONFIG_NET_SCHED=y
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> # CONFIG_SCHEDSTATS is not set
> 
> So no idea what could have started the problem originally.  I guess I
> have to start booting some older kernels and seeing if that helps.

I saw it this morning with 2.6.23.14. It was find for ages, and seems to
be okay again now. Not sure what triggered it though.

nigel@laptop:/usr/src/redhat/BUILD/kernel-2.6.23/build-2.6.23.x86_64$
grep SCHED .config
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_NET_SCHED is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y

(Old Redhat tree with TuxOnIce applied; I'm running F8 with all current
updates applied).

Nigel

