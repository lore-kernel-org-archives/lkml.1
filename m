Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYGNEiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYGNEiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 00:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYGNEiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 00:38:08 -0400
Received: from [194.117.236.238] ([194.117.236.238]:52455 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYGNEiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 00:38:08 -0400
Date: Mon, 14 Jul 2008 07:36:36 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Ryan Hope" <rmh3093@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: Performance Question: BUG_ON vs. WARN_ON_ONCE
Message-ID: <20080714073636.6c84be12@linux360.ro>
In-Reply-To: <48f7fe350807132110k4cd90e9j6907674ea7668f5b@mail.gmail.com>
References: <48f7fe350807131657v4b95340ajfaaacbb04eefa21f@mail.gmail.com>
	<20080714063657.6d1fda18@linux360.ro>
	<48f7fe350807132110k4cd90e9j6907674ea7668f5b@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 00:10:50 -0400
"Ryan Hope" <rmh3093@gmail.com> wrote:

> well the bug I recieved looked like it had to do with highmem and this
> was the only code relating to mem that got touched, as for the other
> person, their crash was reproducible and it definitely was an oops,
> numlock led started to blink and system was unresponsive, for both of
> us
> reverting this change seems fix the issue, my dmesg log is attached to
> this message

There are a few things you should take into account before anything else:
1. The bug does not occur there, but in other code.
2. The kernel is tainted.
3. The oopses start occuring just after you load that tainted module,
or at least something related (that drm stuff is linked to the radeon
module, I presume, which is proprietary AFAIK)

So you should retest after eliminating all these possible noise and
error sources. Test both if your fix (revert) is correct and if it
crashes without your fix.

My guess is that would've happened sooner or later and your fix just
moved stuff around enough to mask it. That static int from WARN_ON_ONCE
means another 4 or 8 bytes in the kernel image, which might set things
off in an already unstable environment.


	Eduard
