Return-Path: <linux-kernel-owner+w=401wt.eu-S1763395AbYARR0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763395AbYARR0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759404AbYARR0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:26:23 -0500
Received: from gw.goop.org ([64.81.55.164]:46632 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759374AbYARR0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:26:22 -0500
Message-ID: <4790E13D.5040603@goop.org>
Date: Fri, 18 Jan 2008 09:26:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: xming <xmingske@gmail.com>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Cannot boot xen DomU > 2.6.23.1
References: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>	 <478F8D22.60004@goop.org>	 <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>	 <4790561E.9040508@goop.org>	 <519a8b110801180438l389ec1d6t7b888b8c78d59dd8@mail.gmail.com>	 <4790D187.8050000@goop.org> <519a8b110801180856o7757889as47106fd3eabcc0de@mail.gmail.com>
In-Reply-To: <519a8b110801180856o7757889as47106fd3eabcc0de@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xming wrote:
>> Would it be possible to map the eip and some top parts of the stack back
>> to kernel symbols?  Seems to be the same place in both traces, which is
>> interesting.
>>     
>
> Can you tell me how, or show me some pointers?
>   

Do "nm -n vmlinux" on the kernel to set an address sorted list of 
symbols, and then look to see what's near the eip (c037c0c7) and near 
the top of the stack (c0100add, c0378980, c0101962, ...).  Some of these 
may be in data, or other strange places, but the ones which correspond 
to code are interesting.

>>> Scenario 2 (have_vcpu_info_placement = 0)
>>> --------------------------------------------------------------
>>>
>>> test1: no crash
>>> test2: no crash, but occationally I still get funny output like this
>>>
>>> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>> 0000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>> 000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>> 000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>>>
>>>       
>> Hm, I guess some of the output is getting dropped.  Does this happen
>> with 2.6.18-xen?
>>     
>
> yes it does
>   

OK, good.  I Didn't Break It (tm) ;)

    J
