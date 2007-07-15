Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbXGOPfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbXGOPfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 11:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXGOPfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 11:35:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:48367 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635AbXGOPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 11:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=UWuzCGbiXUzsf13bk8d9HdNN72fca3moGHwxyLJijzUYUY3dH0tkIda93lMORM1rQflIHhSNTl8zvFxgmJXUtYQOrXUYwk0/a1UIgY98j3BD/kGvBxA/HlfCWluGdhQchgfGmD4dwJ5xQal4ysEXNf++VjaQRAcdw2FygdeEF8o=
Message-ID: <469A3EB9.8000304@gmail.com>
Date: Sun, 15 Jul 2007 21:05:21 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm
Subject: Re: Hibernation considerations
References: <200707151433.34625.rjw@sisk.pl> <200707151810.33554.a1426z@gawab.com>
In-Reply-To: <200707151810.33554.a1426z@gawab.com>
X-Enigmail-Version: 0.95.2
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> 
> This should be the responsibility of the kexec'd hibernating kernel.  Note 
> though in (6), the normal kernel takes care of preparing devices, then the 
> hibernating kernel dumps the image and either calls S4 or S3.  On resume 
> from S3 it can immediately switch over to the normal kernel, and from S4 the 
> known bootup would occur.
> 
>> (8) Hibernation and restore should not be too slow
>>
>>     In my opinion, if more than one minute is needed to hibernate the
>> system with the help of certain hibernation framework, then this framework
>> is not very useful in practice.  It might be useful to perform some
>> special tasks (eg. moving a server to another place without taking it
>> down), but it is not very useful, for example, to notebook users.
> 
> The latest hibernating kexec patches boot a kexec'd modular kernel with 
> initramfs into crashkernel=16M@16M in less than one second.  Switch-back is 
> almost instant.  Add to this the time required to either store or restore 
> the image, and it may be obvious that this approach isn't slower, but maybe 
> even faster than the current swsusp.
> 

What about (9)? Would it be that a user choosing to build a kernel with
hibernate support gets a additional modular kernel built (which he
should then use for resumption) or he should configure & build the
modular kernel independent of main kernel?

Or will the Linux boot procedure change so that it always goes thru a
modular part followed by kexec (just to be uniform)?

Although the kexec approach seems interesting, the final user-scenario
seems a bit complex (or confusing).

-jb
-- 
Tact is the art of making a point without making an enemy.
