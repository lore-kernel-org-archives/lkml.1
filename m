Return-Path: <linux-kernel-owner+w=401wt.eu-S1762363AbYDUOaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762363AbYDUOaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760691AbYDUOa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:30:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760336AbYDUOa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:30:27 -0400
Message-ID: <480CA337.3090709@zytor.com>
Date: Mon, 21 Apr 2008 10:22:47 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>, mingo@elte.hu,
       akpm@osdl.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <20080421140054.GB4685@ucw.cz>
In-Reply-To: <20080421140054.GB4685@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2008-04-17 16:14:10, Mathieu Desnoyers wrote:
>> (hopefully finally CCing LKML) :)
>>
>> Implements an alternative iret with popf and return so trap and exception
>> handlers can return to the NMI handler without issuing iret. iret would cause
>> NMIs to be reenabled prematurely. x86_32 uses popf and far return. x86_64 has to
>> copy the return instruction pointer to the top of the previous stack, issue a
>> popf, loads the previous esp and issue a near return (ret).
> 
> sounds expensive. Does it slow down normal loads?
> 

It should *only* be used to return from NMI, #MC or INT3 (breakpoint), 
which should never happen in normal operation, and even then only when 
interrupting another NMI or #MC handler.

	-hpa

