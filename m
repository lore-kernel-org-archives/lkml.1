Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYKQUZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYKQUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKQUZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:25:48 -0500
Received: from gw.goop.org ([64.81.55.164]:53748 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYKQUZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:25:47 -0500
Message-ID: <4921D349.1040204@goop.org>
Date: Mon, 17 Nov 2008 12:25:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu>	 <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu>	 <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>	 <20081110094033.GL22392@elte.hu>	 <20081110015511.453a801e.akpm@linux-foundation.org>	 <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>	 <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu>	 <491C8B38.9060901@kernel.org>	 <20081113131850.d94fb229.akpm@linux-foundation.org> <1226869137.7178.175.camel@pasglop> <4920B069.5020203@kernel.org> <4920B15E.6090200@zytor.com> <4920B2A4.4040900@kernel.org> <4920B3E3.4050707@zytor.com> <4920B911.7060504@kernel.org>
In-Reply-To: <4920B911.7060504@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> H. Peter Anvin wrote:
>   
>> Yinghai Lu wrote:
>>     
>>> H. Peter Anvin wrote:
>>>       
>>>> Yinghai Lu wrote:
>>>>         
>>>>> 2. make irq number is bus/devfn/idx, and every dev func will use 12bit range, irq number is relatively fixed not like current MSI irq creating is some kind of floating from NR_IRQS too. 
>>>>>           
>>>> 2 is *STILL WRONG*, dammit!
>>>>
>>>> You keep bringing this one up, but our PCI addressing is
>>>> *DOMAIN*/bus/devfn -- it falls flat on its face when you have more than
>>>> 16 PCI domains.  CAN WE PLEASE STOP WITH THIS FOOLISHNESS NOW!
>>>>         
>>> you want to u64 instead of unsigned int for irq?
>>>
>>>       
>> No, I think the whole notion of a static *numeric* identifier for an IRQ
>> when it's something like MSI-X is simply pointless.  I think we should
>> assign IRQ numbers beyond the legacy range dynamically.
>>
>> I really don't think anyone gives a hoot about the IRQ number for any
>> IRQ above the 0-15 legacy range, even including the "APIC" numbers 16+.
>>     
>
> you want to change ioapic/pin to irq mapping too?
>   

I would like to see that.  I'm already doing this in the Xen dom0 code 
interrupt code that I posted the other day.

    J
