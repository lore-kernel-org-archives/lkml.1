Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZCCXwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZCCXwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 18:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZCCXwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 18:52:01 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:3405 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZCCXwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 18:52:00 -0500
MIME-Version: 1.0
In-Reply-To: <20090303135750.GC5060@elf.ucw.cz>
References: <200902192215.18365.rjw@sisk.pl> <200902272155.42010.rjw@sisk.pl>
	 <d6200be20902271456w77951afata1d5f378ddbe6b84@mail.gmail.com>
	 <200902281118.14595.rjw@sisk.pl>
	 <d6200be20902281357r2d3a0075q77055c1781f174d7@mail.gmail.com>
	 <20090303135750.GC5060@elf.ucw.cz>
Date: Tue, 3 Mar 2009 15:51:58 -0800
Message-ID: <d6200be20903031551s1b834c77u1469ef9025fda904@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 5:57 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> If you ignore wakelocks with timeouts, the current
>> >> wakelock interface can be implemented with a global atomic_t to
>> >> prevent suspend, and a per wakelock atomic_t to prevent a single
>> >> client from changing the global reference count by more than one.
>> >>
>> >> There are a couple of reasons that I have not done this. It removes
>> >> the ability to easily inspect the system when it is not suspending.
>> >
>> > Care to elaborate?
>>
>> If you have a single atomic_t and it is not 0, you do not know who
>> incremented it.
>
> Which is okay for already debugged system. For debugging, yes some
> support can be nice.

Yes, but installing an app can turn your debugged system into an
undebugged system. I think is fine to have a kernel option to disable
all debugging support, I just don't think it is the top priority. I
have two options for making the no-stats no-timeout configuration
faster. Option one, always use a reference count, and implement the
other configurations on top of this. This makes the shipping
configuration slower. Option two, use a completely separate
implementation when stats or timeouts are enabled. This makes the fast
version virtually untested. Neither of these are very appealing at the
moment.

-- 
Arve Hjønnevåg
