Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYGUNXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYGUNXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYGUNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:23:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbYGUNXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:23:46 -0400
Message-ID: <48848DDF.6010903@zytor.com>
Date: Mon, 21 Jul 2008 06:23:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
 boot
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>
In-Reply-To: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> This bug seems to be present since 2.6.22 [1], so hope we can get this
> fixed ASAP. Let me know if you have patch suggestions I can test.
> 
> This crashes very early, I had to use earlyprintk to get it.
> 
> BUG: Int 6: CR2 00000000
>      EDI 00000000  ESI 0009f000  EBP 00000000  ESP c036ff60
>      EBX c03e6070  EDX 00000006  ECX 0000009f  EAX c034d240
>      err 00000000  EIP c0387ac2   CS 00000060  flg 00010016
> Stack: 00000000 00000000 c03b63d8 c037bb11 0001dff0 00003c00 c0399614 c03b6304
>        00822007 c037aeb4 c0304134 000001df c0304117 00000000 30303030 205d3030
>        00000000 c034c794 00000000 00000000 00822007 c02b921f c034c794 00000000
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26 #1

Use objdump -d or something to find out what is at 0xc0387ac2; the error 
is an undefined instruction exception.

I suspect this is another case of a processor reporting family == 6 and 
not providing the 0F 1F NOP opcodes.

	-hpa
