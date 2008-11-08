Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYKHQi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYKHQi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 11:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYKHQiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 11:38:19 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:57735 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbYKHQiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 11:38:18 -0500
To: akpm@linux-foundation.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       takedakn@nttdata.co.jp, haradats@nttdata.co.jp,
       penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 06/11] Common functions for TOMOYOLinux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20081104060847.086543472@nttdata.co.jp>
	<20081104060951.618445959@nttdata.co.jp>
	<20081105151221.d605226f.akpm@linux-foundation.org>
In-Reply-To: <20081105151221.d605226f.akpm@linux-foundation.org>
Message-Id: <200811090138.GBG65138.FVOHOJOtMLQFFS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 9 Nov 2008 01:38:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> > +static bool is_select_one(struct tmy_io_buffer *head, const char *data)
> > +{
> > +	unsigned int pid;
> > +	struct domain_info *domain = NULL;
> > +
> > +	if (sscanf(data, "pid=%u", &pid) == 1) {
> 
> PIDs are no longer system-wide unique, and here we appear to be
> implementing new userspace ABIs using PIDs.
> 
I'm not familiar with virtualized environment.

There are two PIDs, PID seen from inside virtualized environment and
PID seen from outside virtualized environment. To clarify, let me call
the former "PIDv" and the latter "PIDg".

PIDv is not system-wide unique. But PIDg is system-wide unique, aren't they?
The PID received from outside virtualized environment is PIDg and they are
system-wide unique, am I right?

This interface is designed to be accessed from outside virtualized environment.
Maybe some checks to prevent processes inside virtualized environment from
accessing this interface are needed.

Regards.
