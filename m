Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZFTAVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZFTAVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 20:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbZFTAVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 20:21:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:35891 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZFTAV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 20:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <1245451983.32124.25.camel@desktop>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
Date: Fri, 19 Jun 2009 17:13:16 -0700
Message-ID: <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 3:53 PM, Daniel Walker<dwalker@fifo99.com> wrote:
> On Fri, 2009-06-19 at 12:20 -0700, Brian Swetland wrote:
>> 2009/6/17 Daniel Walker <dwalker@fifo99.com>:
>> > On Wed, 2009-06-17 at 14:26 -0700, Arve Hjønnevåg wrote:
>> >> On Wed, Jun 17, 2009 at 9:31 AM, Jeremy Fitzhardinge<jeremy@goop.org> wrote:
>> >> > On 06/17/09 09:08, Daniel Walker wrote:
>> >> ...
>> >> > Also, what its usermode ABI is, how stable it is, whether its generally
>> >> > useful, does it have glibc/other library support, etc.  Would you ever want
>> >> > to use this in a non-Android context?
>> >>
>> >> You could use this in a non-android context, but the abi is not
>> >> stable. There is some documentaion of the current user space api at
>> >> http://developer.android.com/reference/android/os/IBinder.html. You
>> >> can also find more information at http://www.open-binder.org/ which is
>> >> where the api came from.
>> >
>> > Why does all this need to be done in the kernel? Couldn't any of the
>> > current IPC mechanisms be re-used to accomplish this?
>>
>> Arve can probably go into more detail here, but I believe the two
>> notable properties of the binder that are not present in existing IPC
>> mechanisms in the kernel (that I'm aware of) are:
>> - avoiding copies by having the kernel copy from the writer into a
>> ring buffer in the reader's address space directly (allocating space
>> if necessary)
>
> This sounds like a performance speed up ..
>
>> - managing the lifespan of proxied remoted userspace objects that can
>> be shared and passed between processes (upon which the userspace
>> binder library builds its remote reference counting model)
>
> The "managing the lifespan" sounds very much like part of the
> description for DBus ..  I think the main competing interface would be
> DBus. I know it's used in the software for the OpenMoko phone , and I
> think the Palm Pre uses it too.
>
> Did Google evaluate DBus at all?

Some of our user-space code have in the past used or still use dbus,
but as far as I know it has not been seriously considered as a
replacement for the binder.

> Also are there any userspace test cases
> that Google used to test the performance of this interface. Or test
> cases to compare the binder with something like sockets, or any other
> type of IPC?
>
> If Google believes the binder is the right solution for IPC, how was
> that conclusion formed?
>
> Daniel

These are mostly questions for the framework team. The binder driver
is there to support our user space code. At some point we used the
driver from www.open-binder.org, but we ran into, and fixed, a lot of
bugs (especially when processes died), so we determined it would be
faster to rewrite the driver from scratch.

-- 
Arve Hjønnevåg
