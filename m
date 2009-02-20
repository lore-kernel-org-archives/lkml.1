Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZBTXLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZBTXLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbZBTXLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:11:30 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:49882 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbZBTXL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:11:29 -0500
MIME-Version: 1.0
In-Reply-To: <200902202305.09992.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org>
	 <200902192358.13068.oliver@neukum.org>
	 <200902201146.59944.rjw@sisk.pl>
	 <200902202305.09992.oliver@neukum.org>
Date: Fri, 20 Feb 2009 15:11:28 -0800
Message-ID: <d6200be20902201511w4db68e96reaa3b0901437a1d1@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
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

On Fri, Feb 20, 2009 at 2:05 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Freitag 20 Februar 2009 11:46:55 schrieb Rafael J. Wysocki:
>> On Thursday 19 February 2009, Oliver Neukum wrote:
>> > Am Donnerstag 19 Februar 2009 23:21:46 schrieb Rafael J. Wysocki:
>> > > > That's the whole point behind userspace wakelocks!  They provide a
>> > > > mechanism for userspace to tell the kernel when (as far as userspace
>> >
>> > is
>> >
>> > > > concerned) it is or is not okay to auto-sleep.
>> > >
>> > > Still, one can go further and observe that the user space can in fact
>> > > start automatic suspend by itself whenever it knows it's appropriate
>> > > ...
>> >
>> > User space initiating this is a race condition.
>>
>> Do you mean a race with the other user space processes or with the kernel?
>
> With the set of runnable processes.There's always a window between
> evaluating the current set of runnable tasks and telling the kernel to sleep.
> IMO the most elegant solution would be a task attribute that would signal
> the kernel that a task should not count as keeping the system busy even
> if it is runnable and trigger the sleep in kernel space.

It is not always safe to enter suspend when no tasks are runnable. For
instance, a key event could be on a user space queue, but the code
that reads from that queue has been paged out.

-- 
Arve Hjønnevåg
