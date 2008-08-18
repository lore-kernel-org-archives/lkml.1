Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbYHRKCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbYHRKCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYHRKCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:02:35 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:59286 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYHRKCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:02:34 -0400
Message-ID: <48A948B7.8040807@aitel.hist.no>
Date: Mon, 18 Aug 2008 12:02:31 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: "Press, Jonathan" <Jonathan.Press@ca.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, hch@infradead.org, andi@firstfloor.org,
       viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
References: <1218645375.3540.71.camel@localhost.localdomain><20080813103951.1e3e5827@infradead.org><1218653864.3540.109.camel@localhost.localdomain><20080813143908.38796217@infradead.org><1218723133.3540.137.camel@localhost.localdomain><48A55574.9070508@aitel.hist.no> <1218796645.10800.242.camel@twins> <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Press, Jonathan wrote:
>> -----Original Message-----
>> From: malware-list-bounces@dmesg.printk.net [mailto:malware-list-
>> bounces@dmesg.printk.net] On Behalf Of Peter Zijlstra
>> Sent: Friday, August 15, 2008 6:37 AM
>> To: Helge Hafting
>> Cc: linux-kernel@vger.kernel.org; malware-list@lists.printk.net;
>>     
> hch@infradead.org;
>   
>> andi@firstfloor.org; viro@ZenIV.linux.org.uk;
>>     
> alan@lxorguk.ukuu.org.uk; Arjan van
>   
>> de Ven
>> Subject: Re: [malware-list] TALPA - a threat model? well sorta.
>>
>> On Fri, 2008-08-15 at 12:07 +0200, Helge Hafting wrote:
>>     
>>> It seems to me that this "scan on file open" business is the
>>> wrong way to do things - because it reduces performance.
>>>
>>> If you scan on file open, then your security sw is too late and
>>> getting in the way.
>>>       
>
> The problem is that you have to account for the cases where the malware
> made it onto the system even if you were trying to catch it ahead of
> time.  For example:
>
> - Administrator turns off or reduces AV protection for some reason for
> some period of time.  It happens all the time.
>   
Everything is "dirty" again when AV sw restarts.
> - New infection makes it onto the machine before the signatures have
> caught up with it.  This also happens.  There is an ongoing PR race
> among AV vendors about who was faster on the draw to get out signatures
> to detect some new malware.  The fact that this race exists reflects
> that reality that there is some window during which new malware will
> make it onto some number of machines before the scanners catch up.
>   
And when new signatures arrive, everything is dirty again. Well, you can 
optimize
and say that everything only need to be checked with the new signatures,
since they passed the old ones already. Maybe that helps performance a 
little.

The "clean" concept works fine, just make sure dirtying happens in all these
extra cases.


Helge Hafting
