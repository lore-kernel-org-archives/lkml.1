Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbXGYFOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbXGYFOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXGYFOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:14:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46249 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbXGYFOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:14:05 -0400
Message-ID: <46A6DB04.3000003@zytor.com>
Date: Tue, 24 Jul 2007 22:09:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Keith Owens <kaos@ocs.com.au>
CC: Trent Piepho <xyzzy@speakeasy.org>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <21803.1185331847@ocs10w.ocs.com.au>
In-Reply-To: <21803.1185331847@ocs10w.ocs.com.au>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Owens wrote:
> Trent Piepho (on Tue, 24 Jul 2007 19:31:36 -0700 (PDT)) wrote:
>> Adding __builtin_trap after the
>> asm might be an ok fix.  It will emit a spurious int 6, but that won't even be
>> reached since the asm doesn't return, and it probably be less extra code than
>> the loop.
> 
> int 6 is a two byte instruction, the loop generates jmp with an 8 bit
> offset, also two bytes.  No change in code size.
> 

INT 6 is #UD, so the __builtin_trap() replaces the ud2a as well as the loop.

How far back was __builtin_trap() supported?

	-hpa
