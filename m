Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYBKCYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYBKCYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 21:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYBKCYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 21:24:15 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:14672 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYBKCYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 21:24:14 -0500
Message-ID: <47AFB18F.1020006@hp.com>
Date: Sun, 10 Feb 2008 21:23:11 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, lksctp-developers@lists.sourceforge.net,
       sri@us.ibm.com
Subject: Re: [Lksctp-developers] [PATCH 8/8] : Use FIELD_SIZEOF
References: <Pine.LNX.4.64.0802102115100.23906@ask.diku.dk> <20080210211258.GE1754@martell.zuzino.mipt.ru>
In-Reply-To: <20080210211258.GE1754@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Sun, Feb 10, 2008 at 09:16:04PM +0100, Julia Lawall wrote:
>> --- a/include/net/sctp/sctp.h
>> +++ b/include/net/sctp/sctp.h
>> @@ -618,7 +618,7 @@ static inline int param_type2af(__be16 t
>>  static inline int sctp_sanity_check(void)
>>  {
>>  	SCTP_ASSERT(sizeof(struct sctp_ulpevent) <=
>> -		    sizeof(((struct sk_buff *)0)->cb),
>> +		    FIELD_SIZEOF(struct sk_buff, cb),
>>  		    "SCTP: ulpevent does not fit in skb!\n", return 0);
>>  
>>  	return 1;
> 
> Same here. Use BUILD_BUG_ON instead.

Ack. BUILD_BUG_ON is definitely appropriate here, especially considering
that SCTP_ASSERT compiles to nothing with debugging turned off.

-vlad

> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Lksctp-developers mailing list
> Lksctp-developers@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
> 

