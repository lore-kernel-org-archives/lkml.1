Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYGZSgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYGZSgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYGZSg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:36:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54917 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYGZSg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:36:28 -0400
Message-ID: <488B6E7B.9040908@zytor.com>
Date: Sat, 26 Jul 2008 14:35:39 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
 boot
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>	<48848DDF.6010903@zytor.com>	<43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>	<48851AC2.8030007@zytor.com> <20080722131408.GA12418@elte.hu>	<4885DF9D.2090804@zytor.com> <87prp07b0y.fsf@basil.nowhere.org>
In-Reply-To: <87prp07b0y.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> This was originally supposed to be handled in the early real mode
> head.S code. That is why I put the CPUID checking code in there
> to error out early when you can still print to the console
> using the BIOS functions.
> 
> I suspect this regressed when that code was moved to C, because
> now the C compiler generates CMOV early.
> 
> How about always building the real mode C code with -march=i386?
> It is not performance critical so that is ok.
> 

The real mode code *is* compiled with -march=i386, and in the CMOV case 
it will err out with a legible message.

The issue isn't CMOV at all, it's with long NOPs, which don't have a 
CPUID bit -- they're supposed to be supported if family >= 6, but some 
VIA chips violate that condition.

	-hpa
