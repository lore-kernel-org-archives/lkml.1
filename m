Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZCIUiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZCIUiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZCIUim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:38:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59414 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbZCIUil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:38:41 -0400
Date: Mon, 9 Mar 2009 21:38:36 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>, Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: Re: [PATCH] ftrace: fix crash due to tracing of __naked functions
Message-ID: <20090309203836.GA1458@pengutronix.de>
References: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 09, 2009 at 08:46:40AM +0100, Uwe Kleine-König wrote:
> This is a fix for the following crash observed in 2.6.29-rc3:
> http://lkml.org/lkml/2009/1/29/150
> 
> On ARM it doesn't make sense to trace a naked function because then
> mcount is called without stack and frame pointer being set up and there
> is no chance to restore the lr register to the value before mcount was
> called.
> 
> Compared to the original fix posted to arm-linux-kernel ML on 29 Jan
> 2009 by Abhishek Sagar I only changed the definition of __naked for ARM.
while talking on #linux-rt about this patch I noticed that ARM is
currently the only user of __naked.  So maybe making __naked include
notrace unconditionally (as Abhishek suggested) is the right thing to
do.

Russell: Steven considers this patch more ARM than ftrace related, so he
(and probably Ingo, too) would prefer this to go via your tree.  Or at
least they want your Ack.
 
What do you think?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
