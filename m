Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYKNNRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYKNNRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 08:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYKNNRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 08:17:06 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:19286 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYKNNRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 08:17:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d/pssTmUEFNHiC9/iHOYKlbqwkIZo2ZTSy4W2iiwHuF5gDl1ucnjfhEGG0C1ADbFWo
         n7ZOoj7DsgFeFfz+VGa2vaiPcv68vHnRobAU6JtgsCodtzWJpyIC+VvcG/MYMqT9yqR8
         8QHOW9VRZ7yshycKiwCGwOrl6sH74ok8LW770=
Message-ID: <3aaafc130811140517i19e7f23aye36b98502b253c62@mail.gmail.com>
Date: Fri, 14 Nov 2008 08:17:03 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Olaf van der Spek" <olafvdspek@gmail.com>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <b2cc26e40811140109jfc6b0f3tf33a92afbff33e46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	 <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
	 <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
	 <20081114.005635.131100777.davem@davemloft.net>
	 <b2cc26e40811140109jfc6b0f3tf33a92afbff33e46@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 4:09 AM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> On Fri, Nov 14, 2008 at 9:56 AM, David Miller <davem@davemloft.net> wrote:
>>> Why would you use windowing, ACKs, flow control and encapsulation on localhost?
>>
>> So that you could firewall, shape, redirect, and make other
>> modifications to the traffic, as well as see it in tcpdumps.  That's
>> the power of Linux, and yes people do this stuff and yes people do
>> want these features to work over loopback.
>>
>>> I expected the kernel to copy data directly from user-space of the
>>> sending process to a kernel buffer of the receiving process, much like
>>> UNIX sockets.
>>
>> Then all of the above features and debugging facilities go away.
>
> So instead the recommendation is for all apps to support both TCP and
> Unix sockets?
> If you then use Unix sockets, you still lose all of those facilities
> and as a bonus, your apps are more complex.

Your application will not be much more complex. That's the point of
having generic sockets. You can wrap whatever protocol you want
underneath them. This isn't much harder than being able to read from a
file or switching around to read stdin if the filename the user gives
is "-"

>
> I'd prefer a switch that could be enabled to use such a shortcut for TCP.
> Firewalls should still work mostly (on connect), redirect would still work.
>

I think this is unnecessary, but if you can make a patch and prove
that it speeds up local connections while not slowing down everything
else, have at it.
