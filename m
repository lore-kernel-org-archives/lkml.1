Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbZBZEYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbZBZEYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 23:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZBZEYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 23:24:08 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:59450 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZBZEYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 23:24:07 -0500
MIME-Version: 1.0
In-Reply-To: <m1y6vtkewc.fsf@fess.ebiederm.org>
References: <200902221837.49396.rjw@sisk.pl>
	 <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>
	 <alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>
	 <20090226030050.GA3361@elte.hu>
	 <d6200be20902251931lf563c2aw43d5266e9677e168@mail.gmail.com>
	 <alpine.LFD.2.00.0902251935190.3111@localhost.localdomain>
	 <d6200be20902251950l34d5968q4b553ce8305ebd4b@mail.gmail.com>
	 <alpine.LFD.2.00.0902251956450.3111@localhost.localdomain>
	 <d6200be20902252013v366ce771w8a129e9f3b75927f@mail.gmail.com>
	 <m1y6vtkewc.fsf@fess.ebiederm.org>
Date: Wed, 25 Feb 2009 20:24:03 -0800
Message-ID: <d6200be20902252024ie529433r9790f5d5ec7b8b5a@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
	suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 8:20 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Arve Hjønnevåg <arve@android.com> writes:
>
>> We only have one gpio input driver, but I don't think is good to loose
>> any wakeup interrupts. Any driver that needs an edge triggered wakeup
>> interrupt will have problems if the hardware does not regenerate the
>> interrupt when the host does not respond.
>
> We are not loosing interrupts.  The normal implementation of disable
> is a software disable and sets IRQ_PENDING to ensure we don't loose
> interrupts when the interrupt is disabled.

We loose the wakeup, but yes, the interrupt will be delivered if the
system wakes up for any other reason.

-- 
Arve Hjønnevåg
