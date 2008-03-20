Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYCTW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYCTW0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbYCTW0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:26:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36845 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755009AbYCTW0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:26:40 -0400
X-Sasl-enc: vta66pgyatipGeSi5DgBR9aZ2oXEcW336TVO7X4mhYp0 1206051998
Date: Thu, 20 Mar 2008 19:26:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation
	patchset against -rc6)
Message-ID: <20080320222633.GA20788@khazad-dum.debian.net>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318232037.GA1670@elf.ucw.cz> <20080320151931.GD5615@khazad-dum.debian.net> <47E287D4.3060906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E287D4.3060906@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008, Alexey Starikovskiy wrote:
> Henrique de Moraes Holschuh wrote:
>> On Wed, 19 Mar 2008, Pavel Machek wrote:
>>   
>>>     Also, for polling mode to work on Acers, we need
>>>     to insert a delay.
>>
>> Can we, in the future, always trigger any such performance damaging "fixups"
>> based on DMI white/black lists?  As a rule?
>>   
> Poll mode is not supposed to be entered on any non-broken HW.

We have seen just how much we can trust that, haven't we?

The truth is that even secondary last-resort paths like this need to work
well, and as fast as possible.  As things stand, we DO excercise them a lot
more than we'd expect...

> The fact that it happens now with Thinkpads at suspend is a bug.

Sure, and one we should fix.  That doesn't change the fact that any broken
HW (or one hit by a kernel bug) that is not as broken as some Acers don't
need to take that 5ms hit on every EC transaction, in an EC mode that is
already way too slow without extra help.

> EC region should not be accessed with interrupts of GPEs disabled.

Looks like something we should tack a WARN_ONCE to, at least when in a debug
mode compile?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
