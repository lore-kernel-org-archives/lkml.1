Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZJ1M7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZJ1M7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 08:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZJ1M7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 08:59:04 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:39350 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbZJ1M7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 08:59:02 -0400
Message-ID: <4AE84017.7040101@hp.com>
Date: Wed, 28 Oct 2009 08:59:03 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Eric Paris <eparis@parisplace.org>, Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14474] restorecond going crazy on 2.6.31.4 - inotify regression?
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <200910270924.41037.rjw@sisk.pl> <7e0fb38c0910270732p3a7098d3jc6334e417320295d@mail.gmail.com> <200910272127.40587.rjw@sisk.pl>
In-Reply-To: <200910272127.40587.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 27 October 2009, Eric Paris wrote:
>> It's a restorecond bug.  restorecon acted as if watch descriptors
>> could never be reused.  They weren't on old kernels and it's possible
>> they are reused now.  Restorecon was fixed.
>>
>> http://marc.info/?l=selinux&m=125380417916233&w=2
>>
>> a change in the kernel caused a buggy userspace program to break.  I
>> know how to put the kernel back the way it was, but I don't know if we
>> call this a regression, you guys tell me.
> 
> Yes, we do, AFAICS.  The policy is not to break user space, even if it happens
> to work by accident.

But if we make a rule of "never break even bad user programs" then
we also should never plug security holes because that breaks a
user program expecting that attack vector :)

Silly example, but the point is we need to decide if the
user program would have done something wrong eventually
anyway (as in if the system was up long enough, they would
have hit a duplicate id and failed with the old kernel) so
the kernel change just makes it easy to hit the user code bug.

jim
