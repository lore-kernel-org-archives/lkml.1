Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbZFBE56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbZFBE56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZFBE5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:57:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:50156 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753976AbZFBE5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:57:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19AtJt/BcxAmGaEVdZ91y1D5esje4equOzzkhEre5
	Kg1Pp6vm16wF80
Subject: Re: Linux scheduler capabilities for batch jobs.
From: Mike Galbraith <efault@gmx.de>
To: J Louis <handstogether8@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6f41bd4b0906010641n1b360dffs6eaed72eb24f60f5@mail.gmail.com>
References: <6f41bd4b0906010641n1b360dffs6eaed72eb24f60f5@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 06:57:49 +0200
Message-Id: <1243918669.5697.70.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 09:41 -0400, J Louis wrote:

> My problem is analogous to a parallel make.  Say I have an 8 CPU
> machine, and I run "make -j8".  If the total memory of the 8 jobs
> throws the machine into swap, it begins to thrash and runtime is
> awful.  

Thrashing is more of a VM/IO scheduling concern.

> I believe this is aggravated by the scheduler trying to be
> fair, and keeping all 8 processes running.  

Yup, fair CPU distribution is the process scheduler's mission, and that
allows tasks to compete for other resources.

> If it was possible to tell
> the scheduler that it was OK not to be fair when scheduling these
> processes, I think the total runtime could be reduced if it put some
> of the processes to sleep while others completed.  

The scheduler doesn't know that any given task _ever_ completes.

> Is there a way to
> tell the scheduler it is allowed to do this?  Should there be?

No, and I don't think it's feasible for existing classes.  You could
invent a new scheduling class, but I think you'd need to invent quite a
bit of infrastructure in the VM to make it work well.

OTOH, the process scheduler doesn't, and shouldn't, make IO resource
decisions, we have IO schedulers to manage who gets what IO bandwidth
when.  The same should apply to VM resources.  Seems to me what you
really want is a VM scheduler.

	-Mike

