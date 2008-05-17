Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYEQQAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYEQQAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 12:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYEQQAC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 12:00:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:59736 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbYEQP75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:59:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,501,1204531200"; 
   d="scan'208";a="565747951"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start onX61s laptop
Date: Sat, 17 May 2008 09:02:32 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com>
In-reply-to: <20080517154131.GA7651@mit.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start onX61s laptop
Thread-Index: Aci4NH4X8vG743MPRJ+HmyPn0ccbTAAAgboQ
References: <E1JxGth-0001te-S4@closure.thunk.org> <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com> <20080517154131.GA7651@mit.edu>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <bugme-daemon@bugzilla.kernel.org>, <airlied@linux.ie>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
X-OriginalArrivalTime: 17 May 2008 15:59:50.0609 (UTC) FILETIME=[09BC0C10:01C8B837]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Theodore Tso [mailto:tytso@mit.edu] 
>Sent: Saturday, May 17, 2008 8:42 AM
>To: Pallipadi, Venkatesh
>Cc: linux-kernel@vger.kernel.org; Ingo Molnar; Siddha, Suresh 
>B; bugme-daemon@bugzilla.kernel.org
>Subject: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server 
>failed start onX61s laptop
>
>
>On Sat, May 17, 2008 at 06:21:18AM -0700, Pallipadi, Venkatesh wrote:
>> 
>> Can you please send the complete dmesg after X failure, with 
>patch here
>> and debugpat boot option.
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2657.html
>
>With debugpat enabled, the resulting dump that landed in
>/var/log/messages was something like 1.6 megabytes, so it totally
>overflowed the dmesg buffer.
>
>I've created a Bugzilla attachment of the bzip'ed messages 
>excerpt here:
>
>http://bugzilla.kernel.org/attachment.cgi?id=16174&action=view
>
>The patch above was only available in HTML-only mode (and I couldn't
>find Ingo's patch on lkml.org, so I had to reconstruct it, and then
>forward part it to 2.6.26-rc2-git5).  What I actually used can be
>found here:
>
>http://bugzilla.kernel.org/attachment.cgi?id=16173&action=view
>
>I'm not sure this will be helpful for you, but this should be
>completely trivial for you to reproduce; just use Ubuntu Gutsy on
>Intel Video based laptop, with a 2.6.26-rc2-git4 or more recent
>kernel, and watch it fail.  
>
>For me, I'll just locally revert commit 1c12c4cf since otherwise X
>becomes more-or-less unsuable.  (Getting used to 1024x768 after using
>a 1600x1200 display is one thing; 800x600 is quite another, and the
>performance using the VESA driver is quite abysmal.)
>

Thanks for the log Ted. From first looks, I don't see any PAT related
failures
in the log. And as the revert of the commit 1c12c4cf is fixing the
problem here,
adding the X guys to the thread.

I am thinking that may be X is depending on mprotect changes somehow and
failing when
it cannot change PAT attributes with mprotect call. Keith earlier
mentioned that X
will not depend on this. May be something to do with earlier X version.
Keith?

Thanks,
Venki
