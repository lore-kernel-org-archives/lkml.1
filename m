Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbZABMUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbZABMUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 07:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbZABMUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 07:20:11 -0500
Received: from fias.uni-frankfurt.de ([141.2.248.1]:58648 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbZABMUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 07:20:10 -0500
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, marcel@holtmann.org
Subject: Re: [BUG] Regression in v2.6.28 introduced by: 'USB: skip Set-Interface(0) if already in altsetting 0'
References: <87ljtu7yvi.fsf@scholz.fias.uni-frankfurt.de>
	<20090102120109.GC3027@elte.hu>
Date: Fri, 02 Jan 2009 13:19:51 +0100
In-Reply-To: <20090102120109.GC3027@elte.hu> (Ingo Molnar's message of "Fri, 2
	Jan 2009 13:01:09 +0100")
Message-ID: <871vvlq4rc.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Jan Scholz <scholz@fias.uni-frankfurt.de> wrote:
>
>> Hi,
>> 
>> In v2.6.28 my usb bluetooth device disappears after suspend to ram:
>> 
>> $ hcitool dev
>> Devices:
>> 	hci0	00:0D:93:15:D6:E8
>> $ echo mem > /sys/power/state 
>> $ hcitool dev
>> Devices:
>> $
>> 
>> The problem does not occur with the (older) hci_usb.ko, but only with
>> btusb.ko.
>>  
>> This is the output of lsusb:
>> Bus 001 Device 003: ID 05ac:8203 Apple Computer, Inc. Bluetooth HCI
>> 
>> Bisecting finds commit 24c0996 (USB: skip Set-Interface(0) if already in
>> altsetting 0) as the first bad commit, and indeed if I use 2.6.28 with
>> 24c0996 reverted, the bluetooth device survives suspend to ram.
>> 
>> If you need more information/test/etc please let me know.
>> 
>> Regards,
>> Jan
>> 
>> > commit 24c0996a6b73e2554104961afcc8659534503e0d
>> > Author: Alan Stern <stern@rowland.harvard.edu>
>> > Date:   Mon Dec 1 10:24:41 2008 -0500
>> >
>> >     USB: skip Set-Interface(0) if already in altsetting 0
>> >
>> >     When a driver unbinds from an interface, usbcore always sends a
>> >     Set-Interface request to reinstall altsetting 0.  Unforunately, quite
>> >     a few devices have buggy firmware that crashes when it receives this
>> >     request.
>> >
>> >     To avoid such problems, this patch (as1180) arranges to send the
>> >     Set-Interface request only when the interface is not already in
>> >     altsetting 0.
>> >
>> >     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> here's a fix patch that appears to be dealing with aspects of this commit:
>
>   http://lkml.org/lkml/2009/1/2/47
>
> you might want to give it a try.
>
> 	Ingo
>

Hi Ingo,

That patch is actually just 24c099 reverted, and as I wrote in the
previous post it indeed fixes the problem.

Thanks anyway,
   Jan
