Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZJHJ2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZJHJ2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbZJHJ2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:28:24 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:33494 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbZJHJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:28:23 -0400
MIME-Version: 1.0
In-Reply-To: <20090909092822.GA18355@electric-eye.fr.zoreil.com>
References: <b2cdc9f30909090013q1741da26la73da66f1eef975f@mail.gmail.com>
	 <20090909092822.GA18355@electric-eye.fr.zoreil.com>
Date: Thu, 8 Oct 2009 10:27:10 +0100
X-Google-Sender-Auth: d012dae78cdc3438
Message-ID: <b2cdc9f30910080227s17effd97vf13d7e91b153ad17@mail.gmail.com>
Subject: Re: r8169 ethernet hangs after a pm-suspend (and resume)
From: Alex Bennee <kernel-hacker@bennee.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/9 Francois Romieu <romieu@fr.zoreil.com>:
> Alex Bennee <kernel-hacker@bennee.com> :
> [...]
>> I've just recently gotten suspend working on my system. Unfortunately
>> after the resume event I loose access to the network.
>> As far as the system is concerned the network is configured properly
>> but every attempt to ping local nodes fails with "Host not reachable".
>
> Can the problem be described as "gigabit link setting does not survive
> suspend/resume" ?

Even further experimentation shows that ethernet functionality can
survive the resume for a few minutes before reseting. Once it gets
into this state even rmmod/modprobing the r8169 driver won't unwedge
the driver.

The symptoms are either the driver detecting an unknown MAC or setting
the physical address to 0xfffffffff which is obviously broken. I
suspect the hardware has gotten itself wedged somehow.

Is there any way to hard reset the chipset (without power cycling the
system)?

-- 
Alex, homepage: http://www.bennee.com/~alex/
http://www.half-llama.co.uk
