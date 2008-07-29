Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYG2Oqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYG2Oqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbYG2Oqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:46:37 -0400
Received: from gw.goop.org ([64.81.55.164]:48912 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950AbYG2Oqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:46:36 -0400
Message-ID: <488F2D48.7030305@goop.org>
Date: Tue, 29 Jul 2008 07:46:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
References: <488E534F.2030204@goop.org> <488E5455.6010901@goop.org> <20080729021215.GG30344@one.firstfloor.org> <488EB8BE.8050806@goop.org> <20080729120237.GH30344@one.firstfloor.org>
In-Reply-To: <20080729120237.GH30344@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Yes, but it's only held briefly to put things onto the list.  It doesn't 
>> get held over the whole IPI transaction as the old smp_call_function 
>> did, and the tlb flush code still does.  RCU is used to manage the list 
>> walk and freeing, so there's no long-held locks there either.
>>     
>
> If it bounces regularly it will still hurt.
>   

We could convert smp_call_function_mask to use a multi-vector scheme 
like tlb_64.c if that turns out to be an issue.

    J
