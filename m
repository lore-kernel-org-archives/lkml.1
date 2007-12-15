Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXLOAjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXLOAjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXLOAjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:39:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35778 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbXLOAjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:39:32 -0500
Message-ID: <47632222.4030008@zytor.com>
Date: Fri, 14 Dec 2007 16:38:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arun Thomas <arun.thomas@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>	 <20071214015315.09829a99.akpm@linux-foundation.org>	 <9a8cbed90712140201r6cb287d9w99cc1210c68e8e60@mail.gmail.com>	 <4762586F.8090603@gmail.com>	 <alpine.LFD.0.99999.0712141140310.10584@localhost.localdomain>	 <4762D322.2060101@zytor.com> <9a8cbed90712141600l1a867da0uc7027e502575a7a6@mail.gmail.com>
In-Reply-To: <9a8cbed90712141600l1a867da0uc7027e502575a7a6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Thomas wrote:
> On Dec 14, 2007 2:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Thomas Gleixner wrote:
>>> The problem is caused by an SMI during the calibration routine. We
>>> really need to come up with a solid solution which does not rely on
>>> the periodic timer coming in, when there is something else (HPET,
>>> pm_timer) available.
>> How long is the SMI?
> 
> Is there some instrumentation code somewhere which would allow me to
> determine this? If not, can you give me some hints on where to add the
> instrumentation code?

Well, the most obvious way to do it would be to run the calibration loop 
a large number of times, and observe the statistical variation.  In 
particular, one should see a bi- or multimodal pattern where the 
difference between the peaks amount to the "lost time".

When we have a clue about the loss of time then we can figure out how to 
detect it.

	-hpa
