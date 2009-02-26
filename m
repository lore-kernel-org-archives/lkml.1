Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbZBZENj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbZBZENj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 23:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZBZENa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 23:13:30 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:11069 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZBZEN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 23:13:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0902251956450.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl>
	 <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
	 <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain>
	 <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>
	 <alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>
	 <20090226030050.GA3361@elte.hu>
	 <d6200be20902251931lf563c2aw43d5266e9677e168@mail.gmail.com>
	 <alpine.LFD.2.00.0902251935190.3111@localhost.localdomain>
	 <d6200be20902251950l34d5968q4b553ce8305ebd4b@mail.gmail.com>
	 <alpine.LFD.2.00.0902251956450.3111@localhost.localdomain>
Date: Wed, 25 Feb 2009 20:13:27 -0800
Message-ID: <d6200be20902252013v366ce771w8a129e9f3b75927f@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
	suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
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

On Wed, Feb 25, 2009 at 7:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 25 Feb 2009, Arve Hjønnevåg wrote:
>>
>> I don't think this is a oddball case. It is very common to connect
>> keys or keypads to gpios. If these keys are wakeup keys, it is not OK
>> to loose interrupts during the suspend phase.
>
> .. and how many drivers is that? Is it one or two "gpio input drivers" or
> is it a hundred?
>
> The "common" is not so much about "how many machines", but "in how many
> drivers would you actually do this".

We only have one gpio input driver, but I don't think is good to loose
any wakeup interrupts. Any driver that needs an edge triggered wakeup
interrupt will have problems if the hardware does not regenerate the
interrupt when the host does not respond.

It is not hard to work around this problem in the platform specific
interrupt code, but I think it is a generic problem worth fixing for
every platform.

-- 
Arve Hjønnevåg
