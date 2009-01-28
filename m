Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbZA1He0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbZA1He0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 02:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZA1HeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 02:34:17 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:57859 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZA1HeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 02:34:17 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 23:34:14 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Bron Gondwana <brong@fastmail.fm>
cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <1233125523.19204.1297144311@webmail.messagingengine.com>
Message-ID: <alpine.DEB.1.10.0901272323240.20262@alien.or.mcafeemobile.com>
References: <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de><20090128033824.GA1662@brong.net>
 <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net> <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com> <20090128052630.GA9512@suse.de> <alpine.DEB.1.10.0901272135400.20262@alien.or.mcafeemobile.com>
 <1233125523.19204.1297144311@webmail.messagingengine.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Bron Gondwana wrote:

> On Tue, 27 Jan 2009 22:38 -0800, "Davide Libenzi" <davidel@xmailserver.org> wrote:
> > So today we have three groups of users:
> >
> > - Users that have been hit by the limit
> >   * Those have probably bumped the value up to the wazzoo.
> 
> Yeah, pretty much.  But we've bumped things up to the wazzoo before
> only to discover that our usage crept up there (file-max of 300,000
> being a case on one machine recently.  Appears you can hit that
> pretty easily when you change from smaller machines to 32Gb memory
> 
> That's why the first time we hit file-max, we added a check into
> our monitoring system so we get warned before we hit it.  Any
> fixed limit, I'd want one of these.  Makes me sleep much better
> (literally, the bloody things SMS me if checks start failing)

Why are you wasting your time in tail-chasing a value? If your load is so 
unpredictable that you can't find a proper upper bound (and it almost 
never is), make it unlimited (or redicoulously high enough).
Warned, by which assumption? That the value rises just as much to hit the 
warn, but not to pass the current limit? How about *fail*, if the burst is 
high enough to hit your inexplicably constrained value?
All this in oder to keep as-close-as-the-peak a value that costs no 
resources in pre-allocation terms.




> > - Unaware users with machines having potential of hitting the current
> > limit
> >   * Those, monitor or not, being unaware, they won't notice it until
> >   hits. 
> >     And since rising it costs zero, they'd likely prefer to bump it to
> >     the 
> >     stars instead of monitoring an incrementing by small steps.
> 
> True.  After they spend a day and a half figuring out what's causing
> them out-of-files errors.  They swear a lot and do the wazzoo thing.

And, since they didn't know about the new limit, an even less known 
"monitor" would have help in ...?



- Davide

