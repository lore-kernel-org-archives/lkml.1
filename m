Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYKNJJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYKNJJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYKNJJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:09:29 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:33234 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYKNJJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:09:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Dv/WlKHBrsHqtnSFlfEmaZd5r1WPmIZeN0K6byljn1jwCI9XswbP8VUQl7BJ+MPxSk
         tqSbgoW2lvj1b8VM5/JnD0itg1ixRPOqNWV6EOYidL9NM37TGXnwv5UBRMo8B9D7XxU4
         //eH/mG6qAEWLvb7FOlDaw6s9+mzF0pCZChJU=
Message-ID: <b2cc26e40811140109jfc6b0f3tf33a92afbff33e46@mail.gmail.com>
Date: Fri, 14 Nov 2008 10:09:25 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Cc: jrm8005@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081114.005635.131100777.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	 <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
	 <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
	 <20081114.005635.131100777.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 9:56 AM, David Miller <davem@davemloft.net> wrote:
>> Why would you use windowing, ACKs, flow control and encapsulation on localhost?
>
> So that you could firewall, shape, redirect, and make other
> modifications to the traffic, as well as see it in tcpdumps.  That's
> the power of Linux, and yes people do this stuff and yes people do
> want these features to work over loopback.
>
>> I expected the kernel to copy data directly from user-space of the
>> sending process to a kernel buffer of the receiving process, much like
>> UNIX sockets.
>
> Then all of the above features and debugging facilities go away.

So instead the recommendation is for all apps to support both TCP and
Unix sockets?
If you then use Unix sockets, you still lose all of those facilities
and as a bonus, your apps are more complex.

I'd prefer a switch that could be enabled to use such a shortcut for TCP.
Firewalls should still work mostly (on connect), redirect would still work.
