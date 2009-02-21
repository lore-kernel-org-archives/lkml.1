Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZBUB7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZBUB7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZBUB7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:59:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:48708 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbZBUB7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:59:34 -0500
MIME-Version: 1.0
In-Reply-To: <200902210020.47665.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org>
	 <200902202305.09992.oliver@neukum.org>
	 <d6200be20902201511w4db68e96reaa3b0901437a1d1@mail.gmail.com>
	 <200902210020.47665.oliver@neukum.org>
Date: Fri, 20 Feb 2009 17:59:32 -0800
Message-ID: <d6200be20902201759x7bcf3762k596d543db51ef104@mail.gmail.com>
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

On Fri, Feb 20, 2009 at 3:20 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Samstag 21 Februar 2009 00:11:28 schrieb Arve Hjønnevåg:
>> On Fri, Feb 20, 2009 at 2:05 PM, Oliver Neukum <oliver@neukum.org> wrote:
>> > Am Freitag 20 Februar 2009 11:46:55 schrieb Rafael J. Wysocki:
>> >> On Thursday 19 February 2009, Oliver Neukum wrote:
>
>> > With the set of runnable processes.There's always a window between
>> > evaluating the current set of runnable tasks and telling the kernel to
>> > sleep. IMO the most elegant solution would be a task attribute that would
>> > signal the kernel that a task should not count as keeping the system busy
>> > even if it is runnable and trigger the sleep in kernel space.
>>
>> It is not always safe to enter suspend when no tasks are runnable. For
>> instance, a key event could be on a user space queue, but the code
>> that reads from that queue has been paged out.
>
> In that case you'd have a task waiting for IO. The driver should refuse
> to suspend or wake up the system as IO is completed. It may be
> inefficient to suspend for such a presumably short time, but it is not
> a correctness issue.

In that case, yes. My point was that no-runnable-tasks is not a
sufficient indicator of whether suspend should fail or not. We have no
control of what a user space thread is waiting for though. It could be
waiting on a mutex that is locked by a thread that is marked not to
prevent suspend.


-- 
Arve Hjønnevåg
