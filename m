Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0BRIoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 03:44:32 -0500
Received: from mail-forward2.uio.no ([129.240.10.71]:57750 "EHLO
	mail-forward2.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0BRIoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 03:44:30 -0500
Message-ID: <4B7CFDE4.4010003@simula.no>
Date: Thu, 18 Feb 2010 09:44:20 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100209 Shredder/3.0.2pre
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Netdev <netdev@vger.kernel.org>, eric.dumazet@gmail.com,
       hannemann@nets.rwth-aachen.de, LKML <linux-kernel@vger.kernel.org>,
       shemminger@vyatta.com, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, ebiederm@xmission.com,
       David Miller <davem@davemloft.net>
Subject: Re: [net-next PATCH v4 2/3] net: TCP thin linear timeouts
References: <4B7AAE69.8020701@simula.no> <20100217.163255.133898079.davem@davemloft.net> <alpine.DEB.2.00.1002181040520.9961@melkinpaasi.cs.helsinki.fi>
In-Reply-To: <alpine.DEB.2.00.1002181040520.9961@melkinpaasi.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-UiO-Ratelimit-Test: rcpts/h 11 msgs/h 2 sum rcpts/h 13 sum msgs/h 2 total rcpts 868 max rcpts/h 40 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: AD82387E4C5CCED76912D000ECAF026AB80DE4F7
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 23 total 20643 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 09:41 AM, Ilpo Järvinen wrote:
> On Wed, 17 Feb 2010, David Miller wrote:
> 
>> From: Andreas Petlund <apetlund@simula.no>
>> Date: Tue, 16 Feb 2010 15:40:41 +0100
>>
>>> @@ -341,6 +342,8 @@ struct tcp_sock {
>>>  	u16	advmss;		/* Advertised MSS			*/
>>>  	u8	frto_counter;	/* Number of new acks after RTO */
>>>  	u8	nonagle;	/* Disable Nagle algorithm?             */
>>> +	u8      thin_lto    : 1,/* Use linear timeouts for thin streams */
>>> +		thin_undef  : 7;
>>>  
>>
>> There is now a gap of 3 unused bytes here in this critical
>> core TCP socket data structure.
>>
>> Please either find a way to avoid this hole, or document
>> it with a comment.
> 
> There would be multiple bits free for use in both frto_counter and nonagle 
> byte.
> 

I was playing aroud with this setup:

=========
u8	nonagle     : 4,/* Disable Nagle algorithm?             */
	thin_lto    : 1,/* Use linear timeouts for thin streams */
	thin_dupack : 1,/* Fast retransmit on first dupack      */
	thin_undef  : 2;
=========

Do you think that would do the trick?

Regards,
Andreas
