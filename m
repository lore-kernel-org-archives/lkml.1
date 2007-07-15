Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXGOX4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXGOX4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbXGOX4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:56:04 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:40284
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbXGOX4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:56:03 -0400
Date: Sun, 15 Jul 2007 16:49:55 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <200707160122.09840.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707151644270.25614@asgard.lang.hm>
References: <200707151433.34625.rjw@sisk.pl> <200707160047.28420.rjw@sisk.pl>
 <Pine.LNX.4.64.0707151538130.25614@asgard.lang.hm> <200707160122.09840.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Rafael J. Wysocki wrote:

> On Monday, 16 July 2007 00:42, david@lang.hm wrote:
>> On Mon, 16 Jul 2007, Rafael J. Wysocki wrote:
>>
>>> On Sunday, 15 July 2007 22:13, david@lang.hm wrote:
>>>> On Sun, 15 Jul 2007, Rafael J. Wysocki wrote:
>>>>
>>>>>    The ACPI specification requires us to invoke some global ACPI methods
>>>>>    during the hibernation and during the restore.  Moreover, the ordering of
>>>>>    code related to these ACPI methods may not be arbitrary (eg. some of
>>>>>    them have to be executed after devices are put into low power states etc.).
>>>>
>>>> for a pure hibernate mode, you will be powering off the box after saving
>>>> the suspend image. why are there any special ACPI modes involved?
>>>
>>> Because, for example, on my machine the status of power supply (present
>>> vs not present) is not updated correctly after the restore if ACPI callbacks
>>> aren't used during the hibernation.  That's just experience and it's in line
>>> with the ACPI spec.
>>
>> so if a machine is actually powered off the /dev/suspend process won't
>> work?
>
> No, it sort of works as usual, but after the restore the platform is not in the
> correct state.

this is not hibernate as I and many others are thinking of it.

hibernate as we are thinking would work on basicly any hardware, including 
things with no ACPI or power savings support. and the system could be in 
hibernate mode for any time period.

for that matter, after a system is put into hibernate mode the system 
could be completely disassembled and any components replaced and the 
system would work after a resume (assuming you still have access to the 
suspend image)

>> remember that the system may run a different OS between the hibernate and
>> the resume, makeing any assumptions about what state the hardware is in
>> when you start the resume is a problem.
>
> True, that's problematic.

putting it mildly.

David Lang
