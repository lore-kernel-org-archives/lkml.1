Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYAORdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYAORdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYAORdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:33:12 -0500
Received: from gw.goop.org ([64.81.55.164]:43506 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYAORdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:33:11 -0500
Message-ID: <478CEE45.1040006@goop.org>
Date: Tue, 15 Jan 2008 09:32:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Folding _PAGE_PWT into _PAGE_PCD (was Re: unify pagetable accessors
 patch causes double fault II)
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115135317.GA13493@elte.hu> <478CEA82.9010606@goop.org> <20080115172346.GB2377@one.firstfloor.org>
In-Reply-To: <20080115172346.GB2377@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> BTW, I just noticed that _PAGE_PWT has been folded into _PAGE_PCD.  This 
>> seems like a really bad idea to me, since it breaks the rule that 
>> _PAGE_X == 1 << _PAGE_BIT_X.  I can't think of a specific place where 
>> this would cause problems, but this kind of non-uniformity always ends 
>> up biting someone in the arse.
>>     
>
> Agreed that it's a bad idea.
>
>   
>> I think having a specific _PAGE_NOCACHE which combines these bits is a 
>> better approach.
>>     
>
> CPA series adds that already
>
> +/* Needs special handling for large pages */
> +#define _PAGE_CACHE     (_PAGE_PCD|_PAGE_PWT|_PAGE_PAT)
>   

Good, but isn't the name _PAGE_CACHE misleading?  Or does it mean 
something else in the context of PAT?

    J
