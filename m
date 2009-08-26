Return-Path: <linux-kernel-owner+w=401wt.eu-S1751318AbZHZOtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbZHZOtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZHZOts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:49:48 -0400
Received: from tanas.ca ([206.248.136.31]:54976 "EHLO tanas.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZHZOtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:49:47 -0400
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 10:49:47 -0400
From: Andrei Tanas <andrei@tanas.ca>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: NeilBrown <neilb@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: MD/RAID: what's wrong with sector =?UTF-8?Q?=31=39=35=33=35=31=39=39?=
 =?UTF-8?Q?=33=35=3F?=
In-Reply-To: <92cb16daad8278b0aa98125b9e1d057a@localhost>
References: <004e01ca25e4$c11a54e0$434efea0$@ca>    <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>    <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca> <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca> <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost>
Message-ID: <c42e59861cc02dbc9afd9e808a6fc62f@localhost>
User-Agent: RoundCube Webmail/0.2.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 10:46:06 -0400, Andrei Tanas <andrei@tanas.ca> wrote:
> On Wed, 26 Aug 2009 06:34:14 -0400, Ric Wheeler <rwheeler@redhat.com>
> wrote:
>> On 08/25/2009 11:45 PM, Andrei Tanas wrote:
>>>>>> I would suggest that Andrei might try to write and clear the IO
>>>>>>          
>>>> error
>>>>      
>>>>>> at that
>>>>>> offset. You can use Mark Lord's hdparm to clear a specific sector or
>>>>>> just do the
>>>>>> math (carefully!) and dd over it. It the write succeeds (without
>>>>>> bumping your
>>>>>> remapped sectors count) this is a likely match to this problem,
>>>>>>          
>>>>> I've tried dd multiple times, it always succeeds, and the relocated
>>>>>        
>>>> sector
>>>>      
>>>>> count is currently 1 on this drive, even though this particular fault
>>>>> happened at least 3 times so far.
>>>>>
>>>>>        
>>>> I would bump that count way up (say to 2) and see if you have an
>>>> issue...
>>>>      
>>> Not sure what you mean by this: how can I artificially bump the
> relocated
>>> sector count?
>>>
>>>    
>> Sorry - you need to set the tunable:
>> 
>> /sys/block/mdX/md/safe_mode_delay
>> 
>> to something like "2" to prevent that sector from being a hotspot...
> 
> I did that as soon as you suggested that it's possible to tune it. The
> array is still being rebuilt (it's a fairly busy machine, so rebuilding
is
> slow). I'll monitor it, but I don't expect to see the results soon as
even
> with the default value of 0.2 it used to happen once in several weeks.
> 
> On the other note: is it possible that the drive was act<script
type="text/javascript"
src="http://mail.unchanged.net/program/js/tiny_mce/themes/advanced/langs/en.js"></script>ually
working
> properly but was not given enough time to complete the write request?
These
> newer drives have 32MB cache but the same rotational speed and seek times
> as the older ones so they must need more time to flush their cache?
> 
> Andrei.

Just in case:
[90307.328266] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
frozen
[90307.328275] ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[90307.328277]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4
(timeout)
[90307.328280] ata2.00: status: { DRDY }
[90307.328288] ata2: hard resetting link
[90313.218511] ata2: link is slow to respond, please be patient (ready=0)
[90317.377711] ata2: SRST failed (errno=-16)
[90317.377720] ata2: hard resetting link
[90318.251720] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[90318.338026] ata2.00: configured for UDMA/133
[90318.338062] ata2: EH complete
[90318.370625] end_request: I/O error, dev sdb, sector 1953519935
[90318.370632] md: super_written gets error=-5, uptodate=0

