Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZEVQXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZEVQXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbZEVQXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:23:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:57905 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbZEVQXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:23:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DSKopx2XjHlIJL830GemWpJ8REDqO6NtdCODoY6hCHgWa/3p6EpvB8m0EnWNDW8XG+
         gdiFIg0nrh3xz4O3+TFoTCn5xQCMkC56npfA+yDUYxwAjhatjd5MvPz+pp/SUAN/vqTl
         ChRAOtlDKeo9VoqcBz0AFl+ZZ3yL0vDEeULDc=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905221155140.3006-100000@iolanthe.rowland.org>
References: <20090522162014.5caa0823@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.44L0.0905221155140.3006-100000@iolanthe.rowland.org>
Date: Fri, 22 May 2009 19:23:04 +0300
Message-ID: <1295ed070905220923u32a42c42pd9615e8f9b665815@mail.gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
From: Pantelis Koukousoulas <pktoss@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kyle Moffett <kyle@moffetthome.net>,
       Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > The second part can be solved (among cooperating processes) by use of
>> > port-lock files, with no kernel involvement.  The first part does
>> > require a kernel interface of some sort, but it wouldn't have to be
>> > complicated.  The mere fact that a port-lock file was open could be
>> > enough to prevent automatic configuration, probing, and binding.
>>
>> Given the layout of devices can change fairly arbitarily would the
>> ability to claim specific device identifiers via libusb do the job any
>> better.
>>
>> ie would it be better to expose an interface via libusb that was
>> essentially
>>
>>       reserve_for_userspace(vendorid, devid);
>
> That's a good question.  I'll defer to the interested parties.
> Kyle and Pantelis, what do you think?

When a device needs a reset, it typically comes back with a different VID:PID.
So e.g., qemu would have to know both of those, while in the case
where we bind to ports it doesn't have to know either.
(This is good imho since the device may only have a windows driver and we
save the user from some research/experimentation).

I do understand that VID:PID solves the problem with port numbers changing
though, but I think in the end using ports is still easier for the
user with some
effort from the virtualization program implementor.

Note though, I assume that there is / will be a way to reliably
predict the port
number (at least roughly) given a physical port location. E.g., if I plugged
a device to my front left usb connector and it got port number X, it should
be possible to predict what the port number will be if I reconnect the same
device to the same connector. (This doesn't have to hold across reboots).

Pantelis
