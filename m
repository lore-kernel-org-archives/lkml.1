Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0BRJen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:34:43 -0500
Received: from host64.kissl.de ([213.239.241.64]:40292 "EHLO host64.kissl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab0BRJem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:34:42 -0500
Message-ID: <4B7D01CE.1030101@lastsummer.de>
Date: Thu, 18 Feb 2010 10:01:02 +0100
From: Franco Fichtner <franco@lastsummer.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andreas Petlund <apetlund@simula.no>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Netdev <netdev@vger.kernel.org>, eric.dumazet@gmail.com,
       hannemann@nets.rwth-aachen.de, LKML <linux-kernel@vger.kernel.org>,
       shemminger@vyatta.com, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, ebiederm@xmission.com,
       David Miller <davem@davemloft.net>
Subject: Re: [net-next PATCH v4 2/3] net: TCP thin linear timeouts
References: <4B7AAE69.8020701@simula.no> <20100217.163255.133898079.davem@davemloft.net> <alpine.DEB.2.00.1002181040520.9961@melkinpaasi.cs.helsinki.fi> <4B7CFDE4.4010003@simula.no>
In-Reply-To: <4B7CFDE4.4010003@simula.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andreas Petlund wrote:
> On 02/18/2010 09:41 AM, Ilpo Järvinen wrote:
>   
>> On Wed, 17 Feb 2010, David Miller wrote:
>>
>>     
>>> From: Andreas Petlund <apetlund@simula.no>
>>> Date: Tue, 16 Feb 2010 15:40:41 +0100
>>>
>>>       
>>>> @@ -341,6 +342,8 @@ struct tcp_sock {
>>>>  	u16	advmss;		/* Advertised MSS			*/
>>>>  	u8	frto_counter;	/* Number of new acks after RTO */
>>>>  	u8	nonagle;	/* Disable Nagle algorithm?             */
>>>> +	u8      thin_lto    : 1,/* Use linear timeouts for thin streams */
>>>> +		thin_undef  : 7;
>>>>  
>>>>         
>>> There is now a gap of 3 unused bytes here in this critical
>>> core TCP socket data structure.
>>>
>>> Please either find a way to avoid this hole, or document
>>> it with a comment.
>>>       
>> There would be multiple bits free for use in both frto_counter and nonagle 
>> byte.
>>
>>     
>
> I was playing aroud with this setup:
>
> =========
> u8	nonagle     : 4,/* Disable Nagle algorithm?             */
> 	thin_lto    : 1,/* Use linear timeouts for thin streams */
> 	thin_dupack : 1,/* Fast retransmit on first dupack      */
> 	thin_undef  : 2;
> =========
>
> Do you think that would do the trick?
>   

According to Ilpo, it would be ok to reduce both ftro_counter and
nonagle, so why not join all these into u16 and leave the remaining
free bits documented for other people. Like this:

    u16 frto_counter:x; /* Number of new acks after RTO */
    u16 nonagle:y; /* Disable Nagle algorithm? */
    u16 thin_lto:1; /* Use linear timeouts for thin streams */
    u16 unused:15-x-y;

Not sure about the y and x. Ilpo, can you comment on those values?


Thanks,
Franco
