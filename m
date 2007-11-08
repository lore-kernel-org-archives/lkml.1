Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbXKHBIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbXKHBIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbXKHBIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:08:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492AbXKHBI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:08:29 -0500
Message-ID: <473260F6.6090808@zytor.com>
Date: Wed, 07 Nov 2007 17:05:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       bugme-daemon@bugzilla.kernel.org,
       Samuel Thibault <samuel.thibault@ens-lyon.org>, hannibal@astral.lodz.pl,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Bill Nottingham <notting@redhat.com>
Subject: Re: [Bugme-new] [Bug 9319] New: National characters are not displayed
 under console.
References: <bug-9319-10286@http.bugzilla.kernel.org/> <20071107140450.fc6a5cb5.akpm@linux-foundation.org>
In-Reply-To: <20071107140450.fc6a5cb5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't a regression.  It's an intentional default change.

The default console mode changed from 8-bit legacy to UTF-8 in 2.6.24.

Apparently this user is using a legacy character set (note that it's a 
Slackware machine), and isn't explicitly setting the character set via 
the appropriate escape sequence.

The new default can be overridden via 
/sys/module/vt/parameters/default_utf8 or something like that...

	-hpa

Andrew Morton wrote:
>> On Wed,  7 Nov 2007 13:19:16 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
>> http://bugzilla.kernel.org/show_bug.cgi?id=9319
>>
>>            Summary: National characters are not displayed under console.
>>            Product: Drivers
>>            Version: 2.5
>>      KernelVersion: 2.6.24-rcX
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: Console/Framebuffers
>>         AssignedTo: jsimmons@infradead.org
>>         ReportedBy: hannibal@astral.lodz.pl
>>
>>
>> Most recent kernel where this bug did not occur: 2.6.23
>>
>> Distribution: Slackware
>>
>> Hardware Environment:
>> Toshiba Tecra M1
>> Pentium M 1.6 512MB RAM, ICH4-M chipset, Trident CyberBlade XP4 video card
>>
>> Software Environment: Slackware-current (kbd-1.12, glibs 2.5)
>>
>> Problem Description:
>> The national characters like "ą", "ł" or "ż" are not displayed corectlly
>> under console (no matter vesa framebuffer, or standard vga). Instead of them
>> "?" on strange background is displayed. Problem begins on 2.6.24-rc1 and
>> continues on 2.6.24-rc2. On 2.6.23 everything is OK.
>>
>> Steps to reproduce:
>> Run 2.6.24-rcX kernel and set national console font by setfont.
>>
> 
> Another post-2.6.23 regression.  Possible culprits cc'ed?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
