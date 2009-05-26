Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZEZAF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZEZAF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZEZAFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:05:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZEZAFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:05:51 -0400
Message-ID: <4A1B3241.3080509@zytor.com>
Date: Mon, 25 May 2009 17:05:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org> <200905251610.43071.lkml@morethan.org> <4A1B0ACD.8020502@zytor.com> <200905251803.51478.lkml@morethan.org>
In-Reply-To: <200905251803.51478.lkml@morethan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> 
> Load Effective Address does two's complement arithmetic?
> I'll take your word for it.
> 

LEA, and all other address calculations use 2's-complement arithmetic:

	leal -1(%ebx),%eax
	leal 0xffffffff(%ebx),%eax

... is the same instruction.

However, gcc has been known to optimize out range checks when operating
on signed integers; it is allowed to do this by the C standard, but it
can give surprising results if the user expected wraparound.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

