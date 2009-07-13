Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZGMJCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZGMJCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZGMJCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:02:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60342 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbZGMJCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:02:17 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
From: Andi Kleen <andi@firstfloor.org>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
	<200907121410.39874.rusty@rustcorp.com.au>
	<20090712004524.2f0c4e57@infradead.org>
	<200907121928.28887.rusty@rustcorp.com.au>
	<20090712083227.39939849@infradead.org>
	<20090712173329.GB12054@kroah.com>
	<20090712145804.2f1fce98@infradead.org>
Date: Mon, 13 Jul 2009 11:02:14 +0200
In-Reply-To: <20090712145804.2f1fce98@infradead.org> (Arjan van de Ven's message of "Sun, 12 Jul 2009 14:58:04 -0700")
Message-ID: <87k52d9crt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
> I've seen some of these case, where the distro kernel has something as
> a module, but the other parts of the distro the unconditionally load
> that module always. That makes no sense.

One good reason for this is that if something goes wrong with
the module you can still remove/blacklist the module. This can 
be very useful in distro deployment, where telling users
"please set flag xyz" is much easier than asking them to get 
a special kernel build. It also helps debugging when you're
trying to narrow down where a problem is.

But you can't do that with built-in drivers.

One way to avoid this would be to have a standard way to turn off
drivers/subsystems that are built in on the command line. Right
now that's difficult because the linked kernel doesn't even know
the driver names anymore. 

Perhaps we should keep the module names/metadata even in static
kernel? (and make CONFIG_MODULE on the subsystem level disappear?).

IMHO that would be a great cleanup anyways, avoiding one special
case in the driver build testing.

It would be also nice if you could cat some file in sys and it gave
you the module descriptions for example.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
