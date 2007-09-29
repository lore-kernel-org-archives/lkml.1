Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbXI2IhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbXI2IhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXI2IhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:37:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475AbXI2IhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:37:07 -0400
Date: Sat, 29 Sep 2007 01:37:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Message-Id: <20070929013702.f56ba268.akpm@linux-foundation.org>
In-Reply-To: <200709290232.44573.elendil@planet.nl>
References: <200709282225.21530.elendil@planet.nl>
	<200709290232.44573.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 02:32:44 +0200 Frans Pop <elendil@planet.nl> wrote:

> On Friday 28 September 2007, Frans Pop wrote:
> > My Toshiba Satellite A40 (i386, P4 Mobile) hangs during boot after:
> > Marking TSC unstable due to: possible TSC halt in C2.
> > Time: acpi_pm clocksource has been installed.
> 
> A few new boot attempts show the problem is more likely at:
> Probing IDE interface ide0...
> 
> > It may not actually hang, but rather end up in a loop as after some time
> > the fan goes wild.
> 
> Unfortunately I have no serial port and this seems too early for netconsole, 
> so cannot catch a boot log.
> 
> > Any suggestions where to look before I do a bisect?

Not really, sorry.  I usually start at mm.patch when I don't have a clue.
It mm.patch fails then pop off all the x86 patches (down to
git-ipwireless_cs.patch).

If mm.patch doesn't fail then push on all the memory management patches (up
to mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch).

Two iterations should get you into the culprit zone.

But please do bisect it.  
