Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZHZKe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZHZKe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZHZKe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:34:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbZHZKeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:34:22 -0400
Message-ID: <4A950FA6.4020408@redhat.com>
Date: Wed, 26 Aug 2009 06:34:14 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrei Tanas <andrei@tanas.ca>
CC: "'NeilBrown'" <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: MD/RAID: what's wrong with sector 1953519935?
References: <004e01ca25e4$c11a54e0$434efea0$@ca>    <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>    <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca> <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca>
In-Reply-To: <005401ca25ff$9ac91cc0$d05b5640$@ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 11:45 PM, Andrei Tanas wrote:
>>>> I would suggest that Andrei might try to write and clear the IO
>>>>          
>> error
>>      
>>>> at that
>>>> offset. You can use Mark Lord's hdparm to clear a specific sector or
>>>> just do the
>>>> math (carefully!) and dd over it. It the write succeeds (without
>>>> bumping your
>>>> remapped sectors count) this is a likely match to this problem,
>>>>          
>>> I've tried dd multiple times, it always succeeds, and the relocated
>>>        
>> sector
>>      
>>> count is currently 1 on this drive, even though this particular fault
>>> happened at least 3 times so far.
>>>
>>>        
>> I would bump that count way up (say to 2) and see if you have an
>> issue...
>>      
> Not sure what you mean by this: how can I artificially bump the relocated
> sector count?
>
>    
Sorry - you need to set the tunable:

/sys/block/mdX/md/safe_mode_delay

to something like "2" to prevent that sector from being a hotspot...

ric




