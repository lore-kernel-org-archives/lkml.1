Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYGAI6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYGAI6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYGAI6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:58:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35452 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbYGAI6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:58:45 -0400
Date: Tue, 1 Jul 2008 10:59:26 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xfs-masters@oss.sgi.com, Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Message-ID: <20080701085926.GA31019@elf.ucw.cz>
References: <4744FD87.7010301@goop.org> <20080626150910.GK5642@ucw.cz> <20080629221217.GM29319@disturbed> <200806300122.48204.rjw@sisk.pl> <20080630062956.GN29319@disturbed> <48687F2B.2000402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48687F2B.2000402@goop.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-06-29 23:37:31, Jeremy Fitzhardinge wrote:
> Dave Chinner wrote:
>> On Mon, Jun 30, 2008 at 01:22:47AM +0200, Rafael J. Wysocki wrote:
>>   
>>> On Monday, 30 of June 2008, Dave Chinner wrote:
>>>     
>>>> On Thu, Jun 26, 2008 at 05:09:10PM +0200, Pavel Machek wrote:
>>>>       
>>>>>>> Is this the same thing the per-device IO-queue-freeze patches for
>>>>>>> HDAPS also
>>>>>>> need to do?  If so, you may want to talk to Elias Oltmanns
>>>>>>> <eo@nebensachen.de> about it.  Added to CC.
>>>>>>>             
>>>>>> Thanks for the heads up Henrique. Even though these issues seem to be
>>>>>> related up to a certain degree, there probably are some important
>>>>>> differences. When suspending a system, the emphasis is on leaving the
>>>>>> system in a consistent state (think of journalled file systems), whereas
>>>>>> disk shock protection is mainly concerned with stopping I/O as soon as
>>>>>> possible. As yet, I cannot possibly say to what extend these two
>>>>>> concepts can be reconciled in the sense of sharing some common code.
>>>>>>           
>>>>> Actually, I believe requirements are same.
>>>>>
>>>>> 'don't do i/o in dangerous period'.
>>>>>
>>>>> swsusp will just do sync() before entering dangerous period. That
>>>>> provides consistent-enough state...
>>>>>         
>>>> As I've said many times before - if the requirement is "don't do
>>>> I/O" then you have to freeze the filesystem. In no way does 'sync'
>>>> prevent filesystems from doing I/O.....
>>>>       
>>> Well, it seems we can handle this on the block layer level, by temporarily
>>> replacing the elevator with something that will selectively prevent fs I/O
>>> from reaching the layers below it.
>>>     
>>
>> Why? What part of freeze_bdev() doesn't work for you?
>
> Well, my original problem - which is still an issue - is that a process 
> writing to a frozen XFS filesystem is stuck in D state, and therefore 
> cannot be frozen as part of suspend.

Well, if it is in D state but does not hold any important locks, you
can just add "try_to_freeze()" in the place where it is sleeping,
right?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
