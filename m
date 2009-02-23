Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZBWXNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZBWXNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZBWXNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:13:23 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:37654 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbZBWXNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:13:22 -0500
MIME-Version: 1.0
In-Reply-To: <200902212120.37684.rjw@sisk.pl>
References: <200902192215.18365.rjw@sisk.pl> <200902211047.26787.rjw@sisk.pl>
	 <d6200be20902210232m71700247k8914ca3735563881@mail.gmail.com>
	 <200902212120.37684.rjw@sisk.pl>
Date: Mon, 23 Feb 2009 15:13:19 -0800
Message-ID: <d6200be20902231513h31661a95n63407b5194b56d51@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
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

On Sat, Feb 21, 2009 at 12:20 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday 21 February 2009, Arve Hjønnevåg wrote:
>> On Sat, Feb 21, 2009 at 1:47 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Saturday 21 February 2009, Arve Hjønnevåg wrote:
>> >> On Fri, Feb 20, 2009 at 3:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> > On Saturday 21 February 2009, Arve Hjønnevåg wrote:
>> >> >> On Fri, Feb 20, 2009 at 7:56 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >> > On Friday 20 February 2009, Arve Hjønnevåg wrote:
>> >> >> >> On Fri, Feb 20, 2009 at 2:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >> >> > On Friday 20 February 2009, Arve Hjønnevåg wrote:
>> >> >> >> >> On Thu, Feb 19, 2009 at 2:08 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> [--snip--]
>> >> > The idea is to have both /sys/power/state and /sys/power/sleep at the same
>> >> > time, where /sys/power/state will work just like it does right now.  Sure,
>> >> > there must be mutual exclusion between the two, but that's a matter of
>> >> > implementation IMO.
>> >>
>> >> If you want to only prevent suspend though one interface, you have to
>> >> also pass information to the driver about its suspend hook is being
>> >> called so it can conditionally return -EBUSY. The wakelock interface
>> >> requires less code in each driver.
>> >
>> > Well, I don't think so.  Moreover, it requires you to spread wakelocks all
>> > over the place if you don't use the timeouted ones which, let's face it, is
>> > hardly acceptable.
>>
>> Your method does not reduce the number of places that has to be
>> modified. Any component where we add a wakelock, you have to add a
>> suspend handler to abort suspend when we would have held a wakelock.
>
> Well, maybe not, but it doesn't introduce entirely new API for device drivers.
> Instead, it extends the existing interfaces which I think is more appropriate.

The existing interfaces require polling. I don't think extending these
interfaces to make the polling faster is a better solution than adding
an interface to avoid polling.

Also, with your solution, how would you modify evdev.c to prevent
suspend while the event queue is not empty. This code does not have
any suspend hooks and the queue is not tied to any thread.

-- 
Arve Hjønnevåg
