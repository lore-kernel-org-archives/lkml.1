Return-Path: <linux-kernel-owner+w=401wt.eu-S935250AbXGQR4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935250AbXGQR4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933479AbXGQR4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:56:33 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50778
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884AbXGQR4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:56:31 -0400
Date: Tue, 17 Jul 2007 10:49:52 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Dr. David Alan Gilbert" <linux@treblig.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <20070717174044.GA11212@gallifrey>
Message-ID: <Pine.LNX.4.64.0707171042300.2467@asgard.lang.hm>
References: <200707151433.34625.rjw@sisk.pl> <20070715125855.GA1737@gallifrey>
 <200707160038.12943.rjw@sisk.pl> <Pine.LNX.4.64.0707151526080.25614@asgard.lang.hm>
 <20070717174044.GA11212@gallifrey>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Dr. David Alan Gilbert wrote:

> * david@lang.hm (david@lang.hm) wrote:
>> On Mon, 16 Jul 2007, Rafael J. Wysocki wrote:
>
>>> Encryption is possible with both the userland hibernation (aka uswsusp) and
>>> TuxOnIce (formerly known as suspend2).  Still, I don't consider it as a
>>> "must
>>> have" feature for a framework to be generally useful (many users don't use
>>> it
>>> anyway).
>>
>> he's talking about the main system useing an encrypted device/partition,
>> not the hibernate image being stored encrypted.
>>
>> This would require the main system 'forget' the keys when it does the
>> hinbernate and prompt for it again during the wake-up phase.
>
> Indeed - although as I say I really don't know what you would do with
> apps using the mounts at that point.   Still it seems like a
> sensible requrest from the security side.

along the same lines, it would probably be a good idea to have the ability 
for a system to re-ask for the pass phrase periodicly while the system is 
running.

I see two possible approaches to these issues.

1. implement the periodic re-request capability, and when going into 
hibernate time-out any known pass phrases.

this is a lot of work overall, but the suspend portion is trivial so there 
would not be any suspend surprises.

2. flush the keyring on hibernate and have the resume process re-populate 
it (either by pokeing directly into the memory, or by providing a table 
that the resuming kernel reads from during wake-up to re-populate it)

this is less work, but it's all suspend related so it will get less 
testing.

David Lang
