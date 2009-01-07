Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZAGJbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZAGJbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZAGJb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:31:29 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:49490 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZAGJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:31:26 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuUOIDI9ONQ=
Message-ID: <4964766B.2080105@hartkopp.net>
Date: Wed, 07 Jan 2009 10:31:23 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Michael Marineau <mike@marineau.org>
CC: David Miller <davem@davemloft.net>, jaswinder@infradead.org,
       jgarzik@redhat.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       mchan@broadcom.com
Subject: Re: [PATCH -net-next 3/4] firmware: convert tg3 driver to	request_firmware()
References: <1230626497.24796.26.camel@jaswinder.satnam> <49620AFE.6040409@hartkopp.net> <20090105.160112.119906029.davem@davemloft.net> <20090107031724.GA6118@porter.dyn.128.marineau.org>
In-Reply-To: <20090107031724.GA6118@porter.dyn.128.marineau.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Marineau wrote:
> On Mon, Jan 05, 2009 at 04:01:12PM -0800, David Miller wrote:
>   
>> From: Oliver Hartkopp <oliver@hartkopp.net>
>> Date: Mon, 05 Jan 2009 14:28:30 +0100
>>
>>     
>>> 2. I got this inconsistent lock state, i've not seen before:
>>>       
>> I know what causes it.  It's this change:
>>
>> commit 22604c866889c4b2e12b73cbf1683bda1b72a313
>> Author: Michael Marineau <mike@marineau.org>
>> Date:   Sun Jan 4 17:18:51 2009 -0800
>>
>>     net: Fix for initial link state in 2.6.28
>>
>> It causes us to now call the linkwatch even trigger code inside of
>> software interrupt context, but that is illegal because that code path
>> takes the dev_base_lock rwlock as a writer.
>>
>> I'm going to revert, and Michael will need to find a way to fix the
>> initial link state issue without adding locking problems :-)
>>     
>
> Ok, here's another try. Rather than find a safer way to sync up the
> operstate variable with the normal state flags I decided to just nuke
> operstate entirely, it just duplicated what was already in the state
> flags for the most part. 

Hi Michael,

i just compiled my current net-2.6 with your new patch and had no 
problems booting my machine afterwards.

Holding the relevant information in one place looks like a good approach 
to me even though i did not test the functionality in detail.

Thanks,
Oliver

