Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbZH0JLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbZH0JLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZH0JLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:11:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZH0JLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:11:42 -0400
Subject: Re: PROBLEM: oops
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Pawe=C5=82_Go=C5=82aszewski?= <blues@gda.pl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval.giani@gmail.com>
In-Reply-To: <alpine.LNX.2.00.0908270956420.16876@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>
	 <1251209206.7538.1159.camel@twins>
	 <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy>
	 <1251209734.7538.1160.camel@twins>
	 <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy>
	 <1251211483.7538.1162.camel@twins>
	 <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy>
	 <1251212859.7538.1166.camel@twins>
	 <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy>
	 <1251265742.7538.1192.camel@twins>
	 <alpine.LNX.2.00.0908261113450.16876@fgnss.gnfx.tqn.cy>
	 <alpine.LNX.2.00.0908270956420.16876@fgnss.gnfx.tqn.cy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Aug 2009 11:10:30 +0200
Message-Id: <1251364230.18584.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 09:58 +0200, Paweł Gołaszewski wrote:
> On Wed, 26 Aug 2009, Pawel Golaszewski wrote:
> > > > > > > could you try to reproduce without that?
> > > > > > > 
> > > > > > > CONFIG_GROUP_SCHED=n
> > > > > > I'll try. 
> > > > It seems that problem still exists - system has crashed too. From 
> > > > netconsole: Any ideas? Last kernel I was using is 2.6.27.13 - works 
> > > > fine. None between 13 and 31 tested...
> > > # git log --format=oneline v2.6.27.13..v2.6.27.31 kernel/sched*
> > > 2b46f3769896dc04e1e49144d282e4655677105a wait: prevent exclusive waiter starvation
> > > 
> > > Nothing changed anywhere near the code that is falling apart..
> > 
> > I have 2 machines with the same hardware and similar software. On one 
> > .13 is stable - I will test it on the second one. Should be too.
> 
> I've checked it - 2.6.27.13 is stable for me.
> 
> Conclusion: there is something wrong between 2.6.27.13 and 2.6.27.31
> 
> What can I do about that? I'm not kernel-hacker...

Unless any of the memory debugging options yield a clue the best you can
do is a bisection I'm afraid.

# git log --format=oneline v2.6.27.13..v2.6.27.31 | wc -l
630

Which should be something like 10 kernel builds to find a patch, and
then one more with just that one reverted.
