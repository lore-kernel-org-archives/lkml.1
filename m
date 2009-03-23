Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbZCWNZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbZCWNZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZCWNZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:25:42 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:40905 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbZCWNZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:25:41 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type:
   Content-Transfer-Encoding;
  b=v+xDWo8bytiU37OiEfmngPkYdyZ7dYoloHkSzEfZL1PCh14GKaX6/4KE
   L4VgJx+T7UoR8d6TuIuHTTIwFRAx/uyHD1wNXjtjgGDF+F7j2/VXbgjmi
   EiHk+uQmtq0fAbv;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.38,407,1233529200"; 
   d="scan'208";a="64641773"
X-IronPort-AV: E=Sophos;i="4.38,407,1233529200"; 
   d="scan'208";a="50011809"
Message-ID: <49C78DD1.30406@fujitsu-siemens.com>
Date: Mon, 23 Mar 2009 14:25:37 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] limit CPU time spent in kipmid
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org>
In-Reply-To: <49C3E03E.10506@acm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard wrote:

>>> It's actually already sort of self-tuning.  kipmid sleeps unless there is 
>>> IPMI activity.  It only spins if it is expecting something from the 
>>> controller.

The self-tuning is fine (as long as there is no CPU load, which may slow 
down stuff a lot, see my other posting). But on systems with many 
sensors it will lead to considerable CPU time shown in "top" and other 
tools for kipmid. And this confuses users. Users think that this is the 
hardware vendor's fault - that's why I am sending this patch (if you so 
wish, it is indeed the vendor's fault to use the outdated KCS interface 
- but that's a different discussion, please let's keep it separate).

>>> I've been thinking about this a little more.  Assuming that the self-tuning 
>>> is working (and it appears to be working fine on my systems), that means 
>>> that something is causing the IPMI driver to constantly talk to the 
>>> management controller.  I can think of three things:
>>>
>>>   1. The user is constantly sending messages to management controller.

This is what I did in my benchmark, of course. But also in real systems, 
there are now many sensors (think dozens of DIMMs with several sensors 
on each DIMM) and many events, causing constant IPMI traffic.

>>>   2. There is something wrong with the hardware, like the ATTN bit is
>>>      stuck high, causing the driver to constantly poll the management
>>>      controller.
>>>   3. The driver either has a bug or needs some more work to account for
>>>      something the hardware needs it to do to clear the ATTN bit.

I think both 2.) and 3.) is not the case here.

>>> If it's #1 above, then I don't know if there is anything we can do about 
>>> it.  The patch Martin sent will simply slow things down.

True, but only a little bit. Please look at the numbers in my other posting.

Best regards
Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
