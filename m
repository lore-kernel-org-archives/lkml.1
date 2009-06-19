Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZFSTUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZFSTUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZFSTUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:20:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52041 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZFSTUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:20:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=yzJ7X1K/yJ39OtCY8dYc4Th/Bb5nzlsLnGci8vJkiJ3OkclPxHU71C5X0lKnlv4CG
	pXD+NTwClR3C6fdCIUlWg==
MIME-Version: 1.0
In-Reply-To: <1245274308.5982.268.camel@desktop>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
Date: Fri, 19 Jun 2009 12:20:31 -0700
Message-ID: <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
From: Brian Swetland <swetland@google.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/17 Daniel Walker <dwalker@fifo99.com>:
> On Wed, 2009-06-17 at 14:26 -0700, Arve Hjønnevåg wrote:
>> On Wed, Jun 17, 2009 at 9:31 AM, Jeremy Fitzhardinge<jeremy@goop.org> wrote:
>> > On 06/17/09 09:08, Daniel Walker wrote:
>> ...
>> > Also, what its usermode ABI is, how stable it is, whether its generally
>> > useful, does it have glibc/other library support, etc.  Would you ever want
>> > to use this in a non-Android context?
>>
>> You could use this in a non-android context, but the abi is not
>> stable. There is some documentaion of the current user space api at
>> http://developer.android.com/reference/android/os/IBinder.html. You
>> can also find more information at http://www.open-binder.org/ which is
>> where the api came from.
>
> Why does all this need to be done in the kernel? Couldn't any of the
> current IPC mechanisms be re-used to accomplish this?

Arve can probably go into more detail here, but I believe the two
notable properties of the binder that are not present in existing IPC
mechanisms in the kernel (that I'm aware of) are:
- avoiding copies by having the kernel copy from the writer into a
ring buffer in the reader's address space directly (allocating space
if necessary)
- managing the lifespan of proxied remoted userspace objects that can
be shared and passed between processes (upon which the userspace
binder library builds its remote reference counting model)

Brian
