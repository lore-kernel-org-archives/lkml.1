Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZHMOMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZHMOMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZHMOMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:12:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZHMOMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:12:49 -0400
Message-ID: <4A841E04.8070108@zytor.com>
Date: Thu, 13 Aug 2009 07:07:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>,
       Matthieu CASTET <matthieu.castet@parrot.com>,
       Alain Knaff <alain@knaff.lu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
References: <4A7C14EB.1060701@parrot.com> <20090807130130.GE4455@laptop> <4A7C2BA4.7030408@parrot.com> <20090807135524.GF4455@laptop> <20090807200001.GE31543@n2100.arm.linux.org.uk> <20090807210816.GA29797@merkur.ravnborg.org> <20090811094418.GI9704@pc-ras4041.res.insa> <4A819642.10700@zytor.com> <20090811162730.GM9704@pc-ras4041.res.insa> <4A819CDD.1000700@zytor.com> <20090813093036.GG4051@pc-ras4041.res.insa>
In-Reply-To: <20090813093036.GG4051@pc-ras4041.res.insa>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 02:30 AM, Albin Tonnerre wrote:
> On Tue, Aug 11, 2009 at 09:31:25AM -0700, H. Peter Anvin wrote :
>> On 08/11/2009 09:27 AM, Albin Tonnerre wrote:
>>> So I guess the only options left are either define a dummy raise() function, or
>>> get rid of the divisions like Alain Knaff did in his patch ?
>>>
>> Define a dummy raise, get rid of the divisions, or provide your own
>> division function (there is probably one in the kernel already...)
> 
> Yes, there's such a function in arch/arm/lib/lib1funcs.S, which in turns
> requires the __div0 symbol, defined in arch/arm/kernel/traps.c, and this one
> cannot be used as it brings plenty of symbols that aren't available in the
> pre-boot environment. So anyway, we have to define our own symbols there. Either
> we use libgcc and define raise(), or lib1funcs and define __div0().
> 

I would go with the variant in the kernel, as being a known quantity.

Your __div0 function can just loop forever.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

