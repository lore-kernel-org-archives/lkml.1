Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYGPNjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYGPNjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbYGPNjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:39:00 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:58613 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbYGPNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding:from;
        b=BW7dLQ0CSwkoAwjZyZt2hgHPMrYBWvsUVCXXcLo3shIIs7Mu7lPB3pZXk4vkoWK1ev
         7xRNJt3yQp3y8HkEmiid0Ip6brAjt0YZMo26DeH3oeYYuE66p3cYSBc/y2qgEfyuaoTb
         nN8O26wFiO7LcmwWjhuh6p0fIE53t9QHXP2mY=
Message-ID: <487DF9EC.9060202@bellsouth.net>
Date: Wed, 16 Jul 2008 08:38:52 -0500
Reply-To: jacliburn@bellsouth.net
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ian Jeffray <ian@jeffray.co.uk>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>, csnook@redhat.com,
       jeff@garzik.org
Subject: Re: sendfile() broken with 2.6.26 + Apache 2 ?
References: <487CD7A7.2080800@jeffray.co.uk> <487D893A.5080207@cosmosbay.com> <487DA388.3030104@jeffray.co.uk> <487DBA74.3090800@cosmosbay.com>
In-Reply-To: <487DBA74.3090800@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
From: "J. K. Cliburn" <jcliburn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Ian Jeffray a écrit :
>> Hi Eric,
>>
>> Thanks for directing me to a better list.
>>
>> Further responses below:
>>
>> Eric Dumazet wrote:
>>> CC to netdev where this report might find better answers
>>>
>>> Ian Jeffray a écrit :
>>>> All,
>>>>
>>>> I moved from kernel 2.6.25.4 to 2.6.26 yesterday and observed that
>>>> large files sent via Apache2 are partially corrupt.
>>>>
>>>> This appears to be linked to sendfile() -- disabling the use of
>>>> sendfile in the apache config (EnableSendfile Off) allows it to
>>>> function as normal.

>>>
>>>
>>> What kind of network adapter are you using ? (lspci | grep -i ether)
>>
>> 02:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit 
>> Ethernet Adapter (rev b0)
>>
>>
>>> If you disable TCP segmentation offload on this NIC (ethtool -K eth0 
>>> tso off) , is this problem still present ?
>>
>> Wow.  That 'solves' the problem!  Great.
>>
>> Does this therefore point to an attansic driver issue?
>>
> 
> 
> Yes, maybe related to commit 9d90fb1ac9d97da86e24d9ea947bf2a2f333829a
> In this patch, Jay Cliburn enabled TSO by default for atl1 driver.
> 
> This might be a driver problem, or a generic sendfile() problem, I dont 
> know...

I'm currently traveling and unable to delve into this issue and its 
relation to the atl1 driver.  I should be able to look at it this 
weekend when I get back home.

Jay
