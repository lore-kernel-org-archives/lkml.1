Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZJWTTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZJWTTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 15:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZJWTTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 15:19:41 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52626 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbZJWTTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 15:19:41 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX188gDDXSCDb6cknbt+y1UUy
Date: Fri, 23 Oct 2009 12:19:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH 05/10] omap1: Fix DSP public peripherals support for
	ams-delta
Message-ID: <20091023191939.GJ16230@atomide.com>
References: <20091022221013.27408.443.stgit@localhost> <20091022221216.27408.39863.stgit@localhost> <4AE0E938.7080305@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE0E938.7080305@ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jon Hunter <jon-hunter@ti.com> [091022 16:22]:
>
> Tony Lindgren wrote:
>> From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
>>
>> DSP public peripherals used to work on OMAP1510 based (or all OMAP1 class?)
>> machines as long as old dspgateway code were present in the l-o tree. For
>> several months it is no longer included, breaking support for McBSP1 based
>> audio on Amstrad Delta, for example.
>>
>> This patch, derived from the old dspgateway code, corrects the problem for the
>> board by simply taking the DSP out of reset state, I guess. That way, things
>> should not break when a new dsp code is added to the tree, and the change can
>> be reverted then.
>
> A minor comment/correction here. Although this bit is called "DSP_RST"  
> this does not actually release the DSP from reset. This bit actually  
> releases the reset for the "priority registers (TIPB module), EMIF  
> configuration registers, and the MPUI control logic (partially) in the  
> DSP", thus allowing you to access the DSP peripherals via the MPUI. Bit  
> 1 of the same register, called "DSP_EN", actually releases the DSP reset.

Thanks for clarifying that.

>> If there are any reports on McBSP1 or other DSP public peripherals not working
>> for other OMAP1 machines (I've not heard of any for now), I can prepare a more
>> general patch providing an extra include file with a helper function defined.
>
> This would be necessary for all OMAP15xx based devices that use McBSP1  
> (or McBSP3 for that matter). However, I am not sure if it is common for  
> other boards to use McBSP1 for audio.

Yeah, I guess currently only board-ams-delta.c needs this for audio.
But that could of course change once there are more 15xx boards using ASoC.

Regards,

Tony
