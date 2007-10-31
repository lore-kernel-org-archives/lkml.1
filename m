Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbXJaUcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbXJaUcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXJaUcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:32:12 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:56338 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbXJaUcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:32:12 -0400
Message-ID: <4728E4AC.7010009@student.ltu.se>
Date: Wed, 31 Oct 2007 21:25:16 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Paul Jimenez <pj@place.org>, rgooch@atnf.csiro.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtrr use type bool
References: <20071031035718.A1D9E8B2A@place.org> <47289EE3.8080706@student.ltu.se> <20071031162016.GD27646@csclub.uwaterloo.ca>
In-Reply-To: <20071031162016.GD27646@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Wed, Oct 31, 2007 at 04:27:31PM +0100, Richard Knutsson wrote:
>   
>> Paul Jimenez wrote:
>>     
> ....
>   
>>> -			usage_table[i] = usage_table[replace] + !!increment;
>>> +			usage_table[i] = usage_table[replace] + increment;
>>>  
>>>       
>> This seems a bit strange, using a boolean as an integer (yes I know, it 
>> works but semantically...). What about:
>>
>> +			usage_table[i] = usage_table[replace];
>> +			usage_table[i] += increment ? 1 : 0;
>>     
>
> What is wrong with:
> usage_table[i] = usage_table[replace];
> if (increment)
> 	usage_table[i]++;
>
> I hate code with the '?' operator in general.  It's a conditional either
> way, and at least this way you wouldn't even have to do a store in one
> of the two cases 9although if the compiler can't figure out that is the
> case already, then it really sucks).
>   
I kind of like them :)
But you are right, since the 'else' doesn't do anything, an if() is more 
clear.
> Pauls code at least didn't involve a conditional at all, but on the
> other hand is less clear to read.
>   
Mm, I know. But on the upside, many places had/have some sort of a = b ? 
TRUE : FALSE, which are getting cleaned out.

Richard Knutsson

