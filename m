Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYFJCa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYFJCa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 22:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYFJCas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 22:30:48 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:62256 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYFJCar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 22:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IclZMVLVpJB4pTWhmZ3HLyCM5z06pC7KRqX3FALbIgyhHFrcPTiulQq0EEVy5y4nCN
         zzfHTspqFir5lJ2NKSepQpz4Nsruoktt5HSnGUcZdai5SvXw61kCgLJFnxT5vLOeddqy
         nA0MdjvZ1aNaH9lA/rxpSMiCMkdHx6sTEFU5A=
Message-ID: <28c262360806091930g70c96f59t627b4590ec59f729@mail.gmail.com>
Date: Tue, 10 Jun 2008 11:30:46 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 04/25] free swap space on swap-in/activation
Cc: "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <2f11576a0806090638u445209e7m359c03a4776826be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606202838.390050172@redhat.com>
	 <20080606202858.570020389@redhat.com>
	 <20080606180430.38bf1d82.akpm@linux-foundation.org>
	 <28c262360806081914v357f4093ra1e1e9e36f487eb7@mail.gmail.com>
	 <2f11576a0806090638u445209e7m359c03a4776826be@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 10:38 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi Kim-san,
>
>>> - Can completely optimise the thing away if !CONFIG_SWAP.
>>
>> I think we can optimize more and more in case of if !CONFIG_SWAP.
>> If system are !CONFIG_SWAP, we can never  swap out anonymous pages.
>>
>> Don't we manage anonymous pages with list ?
>>
>> Such system don't need to insert anonymous pages into lru list when fault occur.
>> It is just needless overhead.
>>
>> Also, If we can't reclaim anonymous pages, don't we need anon rmap facility ?
>> I don't know well which subsystems used rmap.
>>
>> If pageout only use anonymous rmap for pageout,
>> we can remove anonymous rmapping code in case of !CONFIG_SWAP
>
> You are right.
> but I think rmap isn't bottle neck in embedded system.
> Why do you want remove that?

I think unnecessary code execution may increase power consumption and
cache footprint.
But I am not sure pageout just only one user in rmap.
If another subsystem (ex, xen, kvm) use rmap for managing memory, we
cannot remove rmap.



-- 
Kinds regards,
MinChan Kim
