Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbXELFmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbXELFmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 01:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXELFmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 01:42:03 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXELFmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 01:42:01 -0400
Message-ID: <46455394.6020302@zytor.com>
Date: Fri, 11 May 2007 22:41:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       jimmy bahuleyan <knight.camelot@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net> <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com> <464551D5.2050709@zytor.com>
In-Reply-To: <464551D5.2050709@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> I don't see why Alan's way is necessarily better; it should work but is
> more heavy-handed as it's disabling *all* optimization such as loop
> invariants across the barrier.
> 

To expand on this further: the way this probably *should* be handled,
Linux-style, is with internally-volatile versions of le32_to_cpup() and
friends.  That obeys the concept that the volatility should be
associated with an operation, not a data structure, and, being related
to an I/O device, should have its endianness explicitly declared.

Right now those macros don't exist, however.

	-hpa
