Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbYAHUwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbYAHUwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbYAHUv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:51:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:51775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbYAHUvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:51:54 -0500
To: Theodore Tso <tytso@mit.edu>
Cc: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
From: Andi Kleen <andi@firstfloor.org>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	<p73odbwqmx2.fsf@bingen.suse.de>
	<slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi>
	<20080108181525.GL27800@mit.edu>
Date: Tue, 08 Jan 2008 21:51:53 +0100
In-Reply-To: <20080108181525.GL27800@mit.edu> (Theodore Tso's message of "Tue\, 8 Jan 2008 13\:15\:25 -0500")
Message-ID: <p734pdoqbva.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:
>
> Now, there are good reasons for doing periodic checks every N mounts
> and after M months.  And it has to do with PC class hardware.  (Ted's
> aphorism: "PC class hardware is cr*p"). 

If these reasons are good ones (some skepticism here) then the correct
way to really handle this would be to do regular background scrubbing
during runtime; ideally with metadata checksums so that you can actually
detect all corruption.

But since fsck is so slow and disks are so big this whole thing
is a ticking time bomb now. e.g. it is not uncommon to require tens
of minutes or even hours of fsck time and some server that reboots
only every few months will eat that when it happens to reboot.
This means you get a quite long downtime. 

-Andi
