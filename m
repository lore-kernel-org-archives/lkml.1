Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbZB0WJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbZB0WJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbZB0WJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:09:17 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:39793 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbZB0WJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:09:16 -0500
MIME-Version: 1.0
In-Reply-To: <200902272154.03539.rjw@sisk.pl>
References: <200902192215.18365.rjw@sisk.pl> <200902271522.41915.rjw@sisk.pl>
	 <20090227142946.GA13650@srcf.ucam.org>
	 <200902272154.03539.rjw@sisk.pl>
Date: Fri, 27 Feb 2009 14:09:12 -0800
Message-ID: <d6200be20902271409y395822c9ic8f1223f6551631c@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 12:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 27 February 2009, Matthew Garrett wrote:
>> On Fri, Feb 27, 2009 at 03:22:39PM +0100, Rafael J. Wysocki wrote:
>> > On Friday 27 February 2009, Pavel Machek wrote:
>> > > Wakelocks done right are single atomic_t... and if you set it to 0,
>> > > you just unblock "sleeper" thread or something. Zero polling and very
>> > > simple...
>> >
>> > Except that you have to check all of the wakelocks periodically in a loop =>
>> > polling.  So?
>>
>> Why do you need to check them? If you're taking this approach you just
>> have something like:
>>
>> suspend_unblock() {
>>       if (atomc_dec_and_test(&suspend_lock))
>>               suspend();
>> }
>>
>> and then check that the lock count is still 0 after device_suspend().
>> There's no need to poll.
>
> I was talking about wakelocks as originally proposed.

Can you be more specific? My wakelock implementation triggers suspend
when the active list becomes empty. No polling required.

-- 
Arve Hjønnevåg
