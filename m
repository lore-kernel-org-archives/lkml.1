Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbZJ0JAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbZJ0JAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932148AbZJ0JAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:00:50 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:24669 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbZJ0JAu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:1>);
	Tue, 27 Oct 2009 05:00:50 -0400
Message-Id: <4AE6C4D3020000780001BF13@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 27 Oct 2009 09:00:51 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Yinghai Lu" <yinghai@kernel.org>, <tglx@linutronix.de>,
       "Takashi Iwai" <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent
	 allocations
References: <4AE06644020000780001B4AD@vpn.id2.novell.com>
 <20091023114825.GH5886@elte.hu>
 <4AE5CA8C020000780001BD09@vpn.id2.novell.com>
 <20091026152246.GB3749@elte.hu>
 <4AE5D238020000780001BD46@vpn.id2.novell.com>
 <20091026201917.GE24682@elte.hu>
In-Reply-To: <20091026201917.GE24682@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 26.10.09 21:19 >>>
>
>* Jan Beulich <JBeulich@novell.com> wrote:
>
>> >>> Ingo Molnar <mingo@elte.hu> 26.10.09 16:22 >>>
>> >* Jan Beulich <JBeulich@novell.com> wrote:
>> >> And any attempt to eliminate the conditional another way would just 
>> >> introduce a very similar conditional elsewhere; with this having a 
>> >> single user (and foreseeably not ever a second one) I would think this 
>> >> would just make the code less readable.
>> >
>> >There's 3 other current uses of DMA_BIT_MASK(24) in arch/x86 - couldnt 
>> >those use ISA_DMA_BIT_MASK too?
>> 
>> Oh, so you didn't mean me to eliminate the conditional in pci-dma.c, 
>> but just to replace the DMA_BIT_MASK(24) here an elsewhere. Sure, I'm 
>> fine with adding this to the patch.
>
>Well, can ISA_BIT_MASK fall back to DMA_BIT_MASK(32) on !CONFIG_ISA? If 
>we have ISA support disabled we might as well pretend the whole world is 
>PCI, right?
>
>That way we'd get rid of that #ifdef in the .c code too.

I can certainly code it that way, but then we can't use it to replace any
instance of DMA_BIT_MASK(24) used to derive the need for GFP_DMA.
So I'm not sure elimination of which of the instances of DMA_BIT_MASK(24)
is more desirable...

Jan

