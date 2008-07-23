Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYGWAdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYGWAdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYGWAc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:32:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59014 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYGWAc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:32:56 -0400
Message-ID: <48867BF9.5010100@zytor.com>
Date: Tue, 22 Jul 2008 20:31:53 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
 boot
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>	 <48848DDF.6010903@zytor.com>	 <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>	 <48851AC2.8030007@zytor.com> <43e72e890807212147p5d19cfact17e719abb338378c@mail.gmail.com> <488614A3.1060400@garzik.org> <48862526.7060704@zytor.com> <488627E2.2060101@garzik.org> <488629D5.4050603@zytor.com> <48866D10.3020907@garzik.org>
In-Reply-To: <48866D10.3020907@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>
>> I am pretty sure CONFIG_X86_GENERIC doesn't disable CMOV, and since 
>> CMOV is a separate CPUID flag it's all good (if the chip doesn't have 
>> it, it'll trap.)
> 
> It's generally more an issue of making sure the compiler is not 
> instructed to issue cmov (-march=i686).
> 

You're missing the point, though.  The issues at hand are:

- Luis' distributor is compiling kernels without CONFIG_X86_GENERIC.
- VIA has CPUs with family == 6 that don't support long NOPs.
- There is no CPUID flag for long NOPs.

So the VIA chips in question sail through the system that's supposed to 
warn that the kernel is using an unsupported feature and have a hard 
crash, instead.

A lot of virtualizers do the same thing, since they don't use proper 
vendor IDs and instead mimic real chips, sigh.

	-hpa
