Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbYF3RnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbYF3RnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYF3RnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:43:09 -0400
Received: from gw.goop.org ([64.81.55.164]:44727 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYF3RnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:43:07 -0400
Message-ID: <48691B25.5040602@goop.org>
Date: Mon, 30 Jun 2008 10:43:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com>	<485947A8.8060801@goop.org> <4859511E.5050605@sgi.com>	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com> <m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
In-Reply-To: <486912C4.8070705@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Eric W. Biederman wrote:
>   
>> Mike Travis <travis@sgi.com> writes:
>>     
> ...
>   
>>> Can we generate a new symbol which would account for LOAD_OFFSET?
>>>       
>> Ouch.  Absolute symbols indeed.  On the 32bit kernel that may play havoc
>> with the relocatable kernel, although we have had similar absolute logic
>> for the last year. With __per_cpu_start and __per_cpu_end so it may
>> not be a problem.
>>
>> To initialize the percpu data you do want to talk to the virtual address
>> at __per_coup_load.  But it is absolute Ugh.  
>>
>> It might be worth saying something like.
>> .data.percpu.start : AT(.data.percpu.dummy - LOAD_OFFSET) {
>> 	DATA(0)                   
>> 	. = ALIGN(align);
>>         __per_cpu_load = . ;                   
>> }
>> To make __per_cpu_load a relative symbol. ld has a bad habit of taking
>> symbols out of empty sections and making them absolute.  Which is why
>> I added the DATA(0).
>>
>> Still I don't think that would be the 64bit problem.
>>
>> Eric
>>     
>
> FYI, I did try this out and it caused the bootloader to scramble the
> loaded data.  The first corruption I found was the .x86cpuvendor.init
> section contained all zeroes.

Well, that's what appeared to be happening with the pre-initialized GDT 
as well, so I'm not sure that's a new symptom.

    J
