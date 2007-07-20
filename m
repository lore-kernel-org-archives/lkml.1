Return-Path: <linux-kernel-owner+w=401wt.eu-S934848AbXGTTbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934848AbXGTTbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764465AbXGTTa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:30:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762703AbXGTTa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:30:27 -0400
Message-ID: <46A10D12.5000903@zytor.com>
Date: Fri, 20 Jul 2007 12:29:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andreas Schwab <schwab@suse.de>, "Luck, Tony" <tony.luck@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Arthur Jones <arthur.jones@qlogic.com>,
       Vasily Tarasov <vtaras@openvz.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, linux-arch@vger.kernel.org
Subject: Re: build fix for x86_64...
References: <617E1C2C70743745A92448908E030B2A01FA46A9@scsmsx411.amr.corp.intel.com> <jezm1rq8gz.fsf@sykes.suse.de> <46A0F4AC.50809@zytor.com> <200707202013.03568.ak@suse.de>
In-Reply-To: <200707202013.03568.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Obviously, this is not a panacea; if the original "struct foo" has also
>> been introduced on 64 bits before the bug is caught, 
> 
> That's usually the case. There is already an established 64bit ABI
> 

This is true.

Kind of makes me wonder if the right thing is to introduce an
"interface" 64-bit type, call it __iu64 (__is64) defined as:

typedef __u64 __attribute__((aligned(8))) __iu64;
typedef __s64 __attribute__((aligned(8))) __is64;

... and encourage people to use it when creating new interfaces.

Don't know if that would do any good.

	-hpa
