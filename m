Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYAFDxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYAFDxj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYAFDxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:53:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:58883 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYAFDxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:53:31 -0500
Subject: Re: Idle loadavg of ~1, maybe MD related
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20080105190506.38dcf45e.akpm@linux-foundation.org>
References: <20071230100614.GX17327@curie-int.orbis-terrarum.net>
	 <20080105013037.a354b33a.akpm@linux-foundation.org>
	 <20080105100455.GB911@curie-int.orbis-terrarum.net>
	 <1199528332.7291.53.camel@pasglop>
	 <20080105190506.38dcf45e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 14:53:12 +1100
Message-Id: <1199591592.7291.69.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Maybe, but we can usually work around it pretty comfortably.
> 
> If smu_set_fan() is only ever called by a kernel thread then we can simply
> flip it over to using wait_for_completion_interruptible().

Hrm... as of today, it's mostly called from a kernel thread but I don't
totally iron out the possibility that we add control to those things via
sysfs... But that's definitely an option for now.

However, that's only part of the problem. There's a lot of I2C accesses
(and other SMU accesses to read SMU based sensors) and I doubt we can
make all of that "magically" interruptible.

I would much prefer if we had a way to tag a kernel thread to not add to
the load average when in interruptible sleep :-)

> If smu_set_fan() is also called from user processes then things aren't so
> easy...

Ben.


