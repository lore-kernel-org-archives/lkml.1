Return-Path: <linux-kernel-owner+w=401wt.eu-S1751772AbYCSWb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbYCSWb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935980AbYCSVEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:04:22 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:38015 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935968AbYCSVET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:04:19 -0400
Message-ID: <47E178FE.6050500@suse.de>
Date: Wed, 19 Mar 2008 23:35:10 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation	patchset
 against -rc6)
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318225201.GA2115@elf.ucw.cz> <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org> <20080319114851.GB21270@atrey.karlin.mff.cuni.cz> <alpine.LFD.1.00.0803190742450.3020@woody.linux-foundation.org> <20080319202323.GA1811@elf.ucw.cz>
In-Reply-To: <20080319202323.GA1811@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> Ok, 7c0... is innocent. Reverting not only the mdelay, but also rest
>>> of drivers/acpi/ec.c patch fixed the
>>> "rc6-breaks-backlight-in-X-over-lid-close", good.
>> Can you clarify a bit?
>>
>> Do you mean that the full revert of 2c81ce4 that already got committed is 
>> sufficient for you, or do you need to totally undo everything we've done 
>> to ec.c since -rc5, and thus also to revert the _other_ revert we did (in 
>> 4af8e10a6c57e7292862bd1703712f0565c7e429)?
> 
> I did some more testing, and realized I was wrong. We need to totally
> undo everything we've done to ec.c since -rc5... (that has small
> sideffect of brightness up/down keys no longer working -- regression
> since 2.6.24, but saves us from "backlight gone after
> closing/reopening lid" which is _NASTY_ regression from 2.6.25-rc5).
> 
> ACPI sucks.
> 
> I.e. this patch:
> 
> 
> Revert ec.c to 2.6.25-rc5 state:
> 
> * this fixes backlight after closing/reopening the lid while in X on
> thinkpad x60
> 
> * unfortunately it breaks fn-home/end keyboard brightness control
It should also break volume up/down/mute keys. Essentially all the keys on Thinkpad.
And it would also be regression to 2.6.24 level.

Regards,
Alex.
