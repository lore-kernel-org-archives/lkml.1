Return-Path: <linux-kernel-owner+w=401wt.eu-S1030754AbXCMQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030754AbXCMQcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030766AbXCMQcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:32:55 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:37336 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030754AbXCMQcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:32:55 -0400
Date: Tue, 13 Mar 2007 17:32:54 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Pavel Emelianov <xemul@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC][PATCH 1/7] Resource counters
Message-ID: <20070313163254.GR8755@MAIL.13thfloor.at>
Mail-Followup-To: Pavel Emelianov <xemul@sw.ru>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	containers@lists.osdl.org, Paul Menage <menage@google.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kirill Korotaev <dev@sw.ru>, Balbir Singh <balbir@in.ibm.com>
References: <45ED7DEC.7010403@sw.ru> <45ED7F69.60108@sw.ru> <45EE39A5.7010804@in.ibm.com> <45EE6769.9060701@sw.ru> <20070309163711.GA3647@MAIL.13thfloor.at> <m1fy8bwqps.fsf@ebiederm.dsl.xmission.com> <20070312011612.GD21861@MAIL.13thfloor.at> <m1bqixtsr1.fsf@ebiederm.dsl.xmission.com> <20070313152150.GK8755@MAIL.13thfloor.at> <45F6C611.7070400@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6C611.7070400@sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 06:41:05PM +0300, Pavel Emelianov wrote:
> >>> PS: atomic_add_unless() didn't exist back then
> >>> (at least I think so) but that might be an option
> >>> too ...
> >> I think as far as having this discussion if you can remove that race
> >> people will be more willing to talk about what vserver does.
> > 
> > well, shouldn't be a big deal to brush that patch up
> > (if somebody actually _is_ interested)
> > 
> >> That said anything that uses locks or atomic operations (finer grained
> >> locks) because of the cache line ping pong is going to have scaling
> >> issues on large boxes.
> > 
> > right, but atomic ops have much less impact on most
> > architectures than locks :)
> 
> Right. But atomic_add_unless() is slower as it is
> essentially a loop. See my previous letter in this sub-thread.

fine, nobody actually uses atomic_add_unless(), or am I
missing something?

using two locks will be slower than using a single
lock, adding a loop which counts from 0 to 100 will
eat up some cpu, so what? don't do it :)

> >> So in that sense anything short of per cpu variables sucks at scale.
> >> That said I would much rather get a simple correct version without the
> >> complexity of per cpu counters, before we optimize the counters that
> >> much.
> > 
> > actually I thought about per cpu counters quite a lot, and
> > we (Llinux-VServer) use them for accounting, but please
> > tell me how you use per cpu structures for implementing 
> > limits
> 
> Did you ever look at how get_empty_filp() works?
> I agree, that this is not a "strict" limit, but it
> limits the usage wit some "precision".
> 
> /* off-the-topic */ Herbert, you've lost Balbir again:
> In this sub-thread some letters up Eric wrote a letter with
> Balbir in Cc:. The next reply from you doesn't include him.

I can happily add him to every email I reply to, but he
definitely isn't removed by my mailer (as I already stated,
it might be the mailing list which does this), fact is, the
email arrives here without him in the cc, so a reply does
not contain it either ...

best,
Herbert

