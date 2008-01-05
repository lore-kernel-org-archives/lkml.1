Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYAEXCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYAEXCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 18:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYAEXB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 18:01:58 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:35308 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752558AbYAEXB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 18:01:57 -0500
Message-ID: <47800C5F.3080907@nigel.suspend2.net>
Date: Sun, 06 Jan 2008 10:01:51 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <200801031215.07145.oliver@neukum.org> <477D5C4F.8050800@nigel.suspend2.net> <200801042154.08758.oliver@neukum.org> <20080105211826.GB25341@elf.ucw.cz>
In-Reply-To: <20080105211826.GB25341@elf.ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Pavel Machek wrote:
> On Fri 2008-01-04 21:54:06, Oliver Neukum wrote:
>> Am Donnerstag, 3. Januar 2008 23:06:07 schrieb Nigel Cunningham:
>>> Oliver Neukum wrote:
>>>> Am Donnerstag, 3. Januar 2008 10:52:53 schrieb Nigel Cunningham:
>>>>> Oliver Neukum wrote:
>>>>>> Am Donnerstag 03 Januar 2008 schrieb Nigel Cunningham:
>>>>>>> On top of this, I made a (too simple at the moment) freeze_filesystems
>>>>>>> function which iterates through &super_blocks in reverse order, freezing
>>>>>>> fuse filesystems or ordinary ones. I say 'too simple' because it doesn't
>>>>>>> currently allow for the possibility of someone mounting (say) ext3 on
>>>>>>> fuse, but that would just be an extension of what's already done.
>>>>>> How do you deal with fuse server tasks using other fuse filesystems?
>>>>> Since they're frozen in reverse order, the dependant one would be frozen
>>>>> first.
>>>> Say I do:
>>>>
>>>> a) mount fuse on /tmp/first
>>>> b) mount fuse on /tmp/second
>>>>
>>>> Then the server task for (a) does "ls /tmp/second". So it will be frozen,
>>>> right? How do you then freeze (a)? And keep in mind that the server task
>>>> may have forked.
>>> I guess I should first ask, is this a real life problem or a
>>> hypothetical twisted web? I don't see why you would want to make two
>>> filesystems interdependent - it sounds like the way to create livelock
>>> and deadlocks in normal use, before we even begin to think about
>>> hibernating.
>> Good questions. I personally don't use fuse, but I do care about power
>> management. The problem I see is that an unprivileged user could make
>> that dependency, even inadvertedly.
> 
> Other problem is that unprivileged user can do it with evil intent. So
> called "denial-of-service" attack.

Only in this case it would be a denial-of-denial-of-service attack,
since it would stop you hibernating or suspending :).

This is still all hypothetical. If I could have a real life case where
this could actually happen, it would help a lot.

Nigel
