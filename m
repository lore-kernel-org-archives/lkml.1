Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZEIRYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZEIRYD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZEIRXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:23:51 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41600 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZEIRXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:23:50 -0400
MIME-Version: 1.0
In-Reply-To: <20090509181559.664b141a@lxorguk.ukuu.org.uk>
References: <ac3eb2510905071612v61a27760hffc684ee87df9249@mail.gmail.com> 
	<Pine.LNX.4.44L0.0905081000140.3010-100000@iolanthe.rowland.org> 
	<ac3eb2510905091000y4c7a6448uce799d00d500fffe@mail.gmail.com> 
	<20090509181559.664b141a@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 9 May 2009 19:23:30 +0200
Message-ID: <ac3eb2510905091023l42747289h56d59f3b0a7b5b90@mail.gmail.com>
Subject: Re: usbfs, claiming entire usb devices
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 9, 2009 at 19:15, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > Yes.  That is, a process shouldn't be allowed to access a locked device
>> > unless that process is the lock holder.
>>
>> You think the pid or the uid would make more sense?
>
> How about neither ?
>
> The standard Unix behaviour is to open the file O_EXCL if you want
> exclusivity. Neither uid or pid are helpful or work in the many
> environments where you want security - in particular where (as is very
> common with user space driver type code) you want parts of your code
> running setuid and parts not, as two processes with different pid and uid
> values.
>
> If O_EXCL is interpeted as exclusive access (versus kernel and re-open of
> the same node) then you can implement the rest of the sematics in user
> space.

Hmm, but his is a lock for "future" device, which did not even show up
at that point the "lock" will be taken. The files would not be opened
a second time.

The lock-file and the device file are two different files, both would
be opened only by one process - and we are playing around here with
the idea how to connect these both processes.

Thanks,
Kay
