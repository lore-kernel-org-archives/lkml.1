Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbZAOXNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbZAOXNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZAOXNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:13:34 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:58377 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbZAOXNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:13:32 -0500
Message-ID: <f73f7ab80901151513l22b6b017gadb49312ac331391@mail.gmail.com>
Date: Thu, 15 Jan 2009 18:13:30 -0500
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "Kyle Moffett" <kyle@moffetthome.net>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Johannes Schindelin" <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: current git kernel has strange problems during bisect
In-Reply-To: <20090115165425.GA7517@bombe-desk.opditex>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901111602.53082.borntraeger@de.ibm.com>
	 <20090111194258.GA4840@uranus.ravnborg.org>
	 <alpine.LFD.2.00.0901111200330.6528@localhost.localdomain>
	 <200901112239.20306.borntraeger@de.ibm.com>
	 <f73f7ab80901131226s6af7730cucf9c44bc2b4f9545@mail.gmail.com>
	 <20090115165425.GA7517@bombe-desk.opditex>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:54 AM, Andreas Bombe <andreas.bombe@mytum.de> wrote:
> On Tue, Jan 13, 2009 at 03:26:09PM -0500, Kyle Moffett wrote:
>> On Sun, Jan 11, 2009 at 4:39 PM, Christian Borntraeger
>> <borntraeger@de.ibm.com> wrote:
>> > In my opinion we should really avoid subtree merges in the future as a curtesy
>> > to people who do the uncool work of testing, problem tracking and bisecting.
>> > </rant>
>>
>> As an alternative, you can relatively easily rewrite the following
>> independent histories:
>>
>> A -- B -- C
>> X -- Y -- Z
>>
>> To look like this:
>>
>> A -- B -- C -- X' -- Y' -- Z'
>>
>> Where X' is (C + sub/dir/X), Y' is (C + sub/dir/Y), etc...
>
> Given that the subtree may have been in development for a long time, it
> is almost a certainty that the older commits may compile on A but not
> on C.  By basing it all on C you create a lot of uncompilable commits
> which hurt bisection just as bad.  At least with missing kernel sources
> it is obvious that an attempt at compilation is futile and a waste of
> time.

No, the older commits will compile just fine as they don't actually
reference the new code from any of the parent makefiles.  It would
effectively be "dead code" until the "merge" in the commit *after* Z'
in which you add lines to "sub/Kconfig" and "sub/Kbuild" which
reference "sub/dir/*".

Cheers,
Kyle Moffett
