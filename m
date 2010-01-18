Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356Ab0ARHaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0ARHaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344Ab0ARHa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:30:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60957 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab0ARHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:30:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FqZ1uVzWIuLzGclbhXOXAhG9eZj6ZZU3lybJVqqzATcPBwfPtYyI0uyA2LnWDNc/1f
         sn2lFQ2Cc0hvFoYnkqH7qVo9XTAnRId9wpwbO95PkBwYJc8GMnEs3ty94UVhLg8tPOQv
         krCa/CCt2geEi0BMN0KnBYtbhcusdQO90ufDk=
Date: Mon, 18 Jan 2010 07:30:18 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100118073018.GA6270@ff.dom.local>
References: <20100109122830.GA4386@del.dom.local> <4B48CC2C.2090403@majjas.com> <4B4E2F89.2050606@majjas.com> <20100113210908.GA3065@del.dom.local> <4B4E3834.3000609@majjas.com> <4B533A46.9050600@majjas.com> <20100117221746.GA3161@del.dom.local> <4B53906B.2020608@majjas.com> <20100117230531.GC3161@del.dom.local> <4B539A0A.2000504@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B539A0A.2000504@majjas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 06:15:22PM -0500, Michael Breuer wrote:
> On 1/17/2010 6:05 PM, Jarek Poplawski wrote:
>> On Sun, Jan 17, 2010 at 05:34:19PM -0500, Michael Breuer wrote:
>>    
>>> On 1/17/2010 5:17 PM, Jarek Poplawski wrote:
>>>      
>>>> On Sun, Jan 17, 2010 at 11:26:46AM -0500, Michael Breuer wrote:
>>>>        
>>>>> On 01/13/2010 04:16 PM, Michael Breuer wrote:
>>>>>          
>>>>>> On 1/13/2010 4:09 PM, Jarek Poplawski wrote:
>>>>>>            
>>>>>>> On Wed, Jan 13, 2010 at 03:39:37PM -0500, Michael Breuer wrote:
>>>>>>>
>>>>>>>              
>>>>> Update: after leaving the system up for a few days, I hit the DMAR
>>>>> error again.
>>>>>          
>>>> My proposal is to send some summary as a new thread, with dmar in the
>>>> subject, and cc-ed dmar maintainers.
>>>>
>>>>        
>>> Not sure I agree. The symptoms are identical to those I hit without
>>> DMAR earlier on. Also, as this issue only happens when there is high
>>> receive load, I'm thinking there's some sort of race between TX and
>>> RX within the sky2 driver, or hardware. I think that DMAR is
>>> correctly catching the error.
>>>      
>> Hmm... OK, then let's wait with this report and go back to testing
>> it "really really long" ;-) without DMAR, and maybe without the
>> last Stephen's patch either? (So only the two things in the current
>> linux-2.6.)
>>
>> Jarek P.
>>    
> Ok - but absent the last patch, I think I still need the pskb_may_pull  
> patch... so it'd be pskb_may_pull and afpacket v3 and no DMAR.

Exactly. Or if it's working for you already, the mainline (2.6.33-rc4)
with the pskb_may_pull patch. And check for warnings from the latter.

>
> Also - not sure if related, but there's still the odd tx side behavior  
> when RX is under load. That I CAN reproduce at will (yesterday's report  
> - no crash, but I confirmed that DHCPOFFER packets are being dropped  
> somewhere after wireshark sees them and before hitting the wire.

I'm not sure either, but until there is no crash it might be some
minor bug or/and missing stat. Btw, you could probably try alternative
test with ping from this overloaded box to the router and win7.

>
> I am also wondering whether or not that testing I did yesterday set up  
> today's hang - perhaps those lost TX packets are corrupting something  
> that manifests worse later.

Maybe, but you wrote earlier they had to fix something around this
DMAR in the meantime, because it triggered much faster during your
previous tests. So, I don't know why you assume this DMAR has to be
correct this time.

Jarek P.
