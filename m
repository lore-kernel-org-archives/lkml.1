Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbYBVHAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbYBVHAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbYBVHAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:00:35 -0500
Received: from nn7.de ([85.214.94.156]:58200 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbYBVHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:00:32 -0500
Subject: Re: 2.6.25-rc2 regression - hang on suspend
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200802220006.39130.rjw@sisk.pl>
References: <1203422386.10992.2.camel@localhost>
	 <200802210131.54272.rjw@sisk.pl> <1203588294.3882.6.camel@localhost>
	 <200802220006.39130.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Feb 2008 08:00:28 +0100
Message-Id: <1203663628.8422.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 00:06 +0100, Rafael J. Wysocki wrote: 
> On Thursday, 21 of February 2008, Soeren Sonnenburg wrote:
> > On Thu, 2008-02-21 at 01:31 +0100, Rafael J. Wysocki wrote:
> > > On Wednesday, 20 of February 2008, Soeren Sonnenburg wrote:
> > > > On Wed, 2008-02-20 at 00:50 +0100, Rafael J. Wysocki wrote:
[...] 
> > Using echo none >/sys/power/pm_test and then
> > echo mem >/sys/power/state I see it hang on ata1 errors again. Waiting
> > about 10-30 seconds it progresses further and finally arrives at 
> > 
> > CPU0 attaching NULL sched-domain
> > CPU1 attaching NULL sched-domain
> > 
> > then hangs.
> 
> Please see if compiling the kernel with CONFIG_SMP unset makes suspend
> work.

*Argh*, this bug is not behaving nicely :( Whatever happened,
git-current now suspends correctly with and without CONFIG_SMP  and all
may CONFIG_PREEMPT_RCU=y and CONFIG_CLASSIC_RCU=y attempts. Also no sata
errors anymore.

However it is not reliably waking up (at least when all of the above
except CLASSIC_RCU is on). Sometimes the display remains black on the
console, but X still works and sometimes it hangs completely on resume.

Also when compiling these many kernels via make -j4 I noted that I could
hardly move the mouse / use the keyboard, but saw random jumps and
key-repetitions...

Soeren
