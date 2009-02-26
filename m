Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZBZU77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZBZU77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZBZU7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:59:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:39250 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbZBZU7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:59:49 -0500
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
 suspend-resume
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <d6200be20902261234i5a3896fo78a7f56d16a247c7@mail.gmail.com>
References: <200902221837.49396.rjw@sisk.pl>
	 <200902250029.16107.rjw@sisk.pl>
	 <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
	 <200902261050.50531.rjw@sisk.pl>
	 <d6200be20902261234i5a3896fo78a7f56d16a247c7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Feb 2009 07:57:29 +1100
Message-Id: <1235681849.7388.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 12:34 -0800, Arve Hjønnevåg wrote:
> That is enough for drivers that use wakelocks to abort suspend (if I
> fix the wakelock code to not use a platform device as its last abort
> point). It is not enough if you don't have wakelocks, since the
> interrupt can occur after suspend_late has been called and the driver
> has no way to abort suspend.
> 
I still don't quite see how you deal with the race anyway. Ie. Even
without Rafael patch, what if the interrupt occurs after your sysdev
suspend ?

In general, unless they are level sensitive, wakeup interrupts tend to
always be somewhat racy.

Cheers,
Ben.


