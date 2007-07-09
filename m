Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbXGIPXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbXGIPXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXGIPXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:23:16 -0400
Received: from sccrmhc12.comcast.net ([204.127.200.82]:39654 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXGIPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:23:15 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: david@lang.hm, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: hibernation/snapshot design
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org>
	<200707082115.27363.rjw@sisk.pl>
	<1183928612.3388.289.camel@localhost.localdomain>
	<200707082345.27859.rjw@sisk.pl>
	<1183931688.3388.316.camel@localhost.localdomain>
	<20070708221315.GF5401@elf.ucw.cz>
	<Pine.LNX.4.64.0707081519210.25614@asgard.lang.hm>
	<20070708230042.GH5401@elf.ucw.cz>
	<Pine.LNX.4.64.0707081614211.25614@asgard.lang.hm>
	<20070708232819.GJ5401@elf.ucw.cz>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 09 Jul 2007 11:23:12 -0400
In-Reply-To: <20070708232819.GJ5401@elf.ucw.cz> (Pavel Machek's message of
	"Mon\, 9 Jul 2007 01\:28\:19 +0200")
Message-ID: <873azxwqhr.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

[snip]

>> why do you say that neither would work for the "lets hibernate my 
>> notebook" case?

> Both would work. One would eat 8-64MB of your RAM, permanently;

As I have stated in other messages, the kdump approach would not waste
any RAM permanently.  The reason that kdump must reserve memory at boot
is that on panic, it cannot attempt to nicely stop drivers, and
consequently there might be ongoing DMAs that could clobber anything but
the reserved area; this reason does not apply to hibernate, though.
I'll quote a previous message in which I stated a solution that can be
used:

Immediately before jumping to the new kernel, the first X bytes (where X
is the amount of memory the new kernel will get, typically 16MB or 64MB)
of physical memory are backed up into the arbitrary discontiguous pages
that are made available.  This will not take very long, because copying
even 64MB of memory is extremely fast.  Then the new kernel is free to
use the first X bytes of contiguous physical memory.  Problem solved.

-- 
Jeremy Maitin-Shepard
