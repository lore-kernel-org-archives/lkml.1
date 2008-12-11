Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYLKXlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYLKXlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbYLKXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:41:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbYLKXlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:41:22 -0500
Message-ID: <4941A42A.7030607@zytor.com>
Date: Thu, 11 Dec 2008 15:37:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Zachary Amsden <zach@vmware.com>, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <alokkataria1@gmail.com>,
       "bruno.premont@restena.lu" <bruno.premont@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27, 2.6.28 kernels
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com> <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com> <1228953980.8766.42.camel@bodhitayantram.eng.vmware.com> <49405CB6.6010006@kernel.org> <20081211033105.GA31972@suse.de> <1229034191.8766.63.camel@bodhitayantram.eng.vmware.com> <20081211214524.GA31581@suse.de>
In-Reply-To: <20081211214524.GA31581@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> +#else
>> +#define vmi_init()
>> +#define vmi_activate()
>> +#define vmi_bringup()
>> +#endif
> 
> static inline please, don't use #defines for function prototypes, it's
> not nice.  See Andrew's previous rants about this for details :)

And if it is not possible, technically, for whatever reason, the proper
forms look like:

#define foo()    ((void)0)
#define bar(x)   ((void)(x))
#define baz(x,y) ((void)((x),(y)))

... which preserve side effects, even if they don't guarantee type safety.

	-hpa
