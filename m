Return-Path: <linux-kernel-owner+w=401wt.eu-S965624AbYD1RAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965624AbYD1RAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965442AbYD1RA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:00:26 -0400
Received: from gw.goop.org ([64.81.55.164]:37142 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965433AbYD1RAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:00:24 -0400
Message-ID: <4816029D.3030508@goop.org>
Date: Mon, 28 Apr 2008 10:00:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Gerhard Mack <gmack@innerfire.net>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25] compat VDSO option not disabling
References: <alpine.DEB.1.10.0804241244360.28216@mtl.rackplans.net> <Pine.LNX.4.64.0804251632490.19002@twin.jikos.cz> <alpine.DEB.1.10.0804261213200.28624@mtl.rackplans.net> <48140ACF.4000500@goop.org> <alpine.DEB.1.10.0804281145090.17060@mtl.rackplans.net>
In-Reply-To: <alpine.DEB.1.10.0804281145090.17060@mtl.rackplans.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Mack wrote:
> On Sat, 26 Apr 2008, Jeremy Fitzhardinge wrote:
>   
>> Gerhard Mack wrote:
>>     
>>> I havn't enabled compat VDSO at the kernel command line or otherwise.
>>> Something broke with this option.   
>>>       
>> Yes, you might be on to something.  I think I've been seeing that message when
>> I wouldn't expect to.  I'll double-check.  Could you send your complete dmesg
>> output?
>>
>>     
> Of course
>
>
> Compat vDSO mapped to ffffe000.
>   

I think this is just a false alarm.  sysenter_setup always prints this, 
but if compat mode isn't enabled this is just the address the compat 
vdso would be at if it were mapped.  You can confirm this by doing "cat 
/proc/self/maps" and making sure that there's nothing mapped at 
ffffe000.  And then cross confirm with "sysctl -w vm.vdso_enabled=2; cat 
/proc/self/maps" to make sure it appears.

    J
