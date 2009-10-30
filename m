Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZJ3NlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZJ3NlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZJ3NlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:41:21 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:47821 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbZJ3NlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bw2Hy9NeegTzL3TRlzgeePHN5/xaL/RlpgXLfRapp01vsFOK0x78KV2L0GHGz7VM7Y
         ubopd9S+7M9WJPUorfUkn8in7UQxfUmENIf3wjzDb/YBIhscN75toGxBDYxgVQTTqONZ
         GaAe403RnaCaFeo6bsCOssHUpamQeZgRSD28M=
MIME-Version: 1.0
In-Reply-To: <38b2ab8a0910300533l4bbc9d3cj8812fe38726c8278@mail.gmail.com>
References: <38b2ab8a0909290109m3f82c161j4fb0f1266152877e@mail.gmail.com>
	 <4AC1D0F5.4050709@gmail.com>
	 <38b2ab8a0910300144i7a3c190fi9aa3d079c9cdb754@mail.gmail.com>
	 <4AEACD88.8080108@gmail.com>
	 <38b2ab8a0910300533l4bbc9d3cj8812fe38726c8278@mail.gmail.com>
Date: Fri, 30 Oct 2009 14:41:24 +0100
Message-ID: <38b2ab8a0910300641q78c08124o800a9dfc9486fba7@mail.gmail.com>
Subject: Re: WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct
From: Francis Moreau <francis.moro@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 1:33 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> On Fri, Oct 30, 2009 at 12:27 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> This oops occurring again and again with SUNRPC finally gave me the right pointer.
>>
>> David, we added two years ago memory accounting to UDP, and this changed
>> requirements about calling skb_free_datagram() in the right context.
>>
>> I wish we had an ASSERT_SOCK_LOCKED() debugging facility :(
>>
>> Francis, would you please test following patch ?
>
> I'm applying it and testing it during a couple of days and see if
> something wrong still happens.

Hmm, with the patch applied on a 2.6.32-rc5, my machine locks hard
when starting nfsd.

-- 
Francis
