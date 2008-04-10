Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYDJWg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYDJWg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYDJWgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:36:48 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:47478 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYDJWgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:36:47 -0400
Date: Fri, 11 Apr 2008 00:36:45 +0200
Message-Id: <234148243@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: lkml@metanurb.dk, pernegger@gmail.com, tvrtko@ursulin.net
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Western Digital GreenPower drives and Linux
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+/pJBhYcxbLdqDRWXg3wy+IE8CG90TUndhfk3Kn3iJ7SXRD
 J+Xd7AiAcSDiC103xedRu4CS+Bs66qFjxMTH7UXCu9nfTesTws=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i also have such a drive (damn, if i knew that saving some Watts would hurt...) - and i measured ~100 load_cycle_count per hour, which is _way_ to much, imho.
if we trust the spec, the disk would be dead after ~1year.

it seems that "intellipark" is not that intelligent as it should be and a little bit too agressive.

from what i have found, the time for parking the heads is much below the linux kernel flush interval (which seems to be at 30secs),  so i think the best thing to do is tuning either dirty_expire_centisecs and dirty_writeback_centisecs  (defaults to 3000/500 on my system)  or tune the disk parking interval , so that the disks own interval is greater than the linux flush interval.

i also openend an SR at WD - will see if they will recommend that dos utility, too.

>I got back from WD's tech support and received a DOS utility which can control 
>this drive feature, apparently using vendor specific commands. With it head 
>unload timer can be disabled or set to a period between 100ms and 25.5s. 

doh - so that disk always is faster with parking it`s heads than linux default flush interval !?
btw - is that dos utility available for download somewhere?

regards
roland



List:       linux-kernel
Subject:    Re: Western Digital GreenPower drives and Linux
From:       "Tvrtko A. Ursulin" <tvrtko () ursulin ! net>
Date:       2008-04-10 7:48:08
Message-ID: 200804100848.08442.tvrtko () ursulin ! net
[Download message RAW]

On Wednesday 09 April 2008 21:18:35 Tvrtko A. Ursulin wrote:
> I got one of them (WD5000AACS) recently and to my horror after less than
> three days of being power on this is what I saw:
>
> 9 Power_On_Hours       0x0032 100 100 000 Old_age Always  - 66
> 193 Load_Cycle_Count 0x0032 197 197 000 Old_age  Always  - 10233
>
> At this rate the disk would reach it's design limit for load/unload cycles
> in around 80 days. Not good - so I implemented a lame workaround of keeping
> disk busy every couple of seconds - hopefully that won't kill it sooner
> that unloads would..
>
> I am also currently talking with first line of WD's tech support trying to
> get some data on how exactly those drives manage head unloading, but that
> may not lead anywhere useful.

I got back from WD's tech support and received a DOS utility which can control 
this drive feature, apparently using vendor specific commands. With it head 
unload timer can be disabled or set to a period between 100ms and 25.5s. 

Of course I asked for more than a DOS utility, but the question really is how 
was this feature intended to work with Windows for example, is there 
something there which would prevent such rapid load/unload cycle growth, and 
why isn't it documented somewhere?

I am kind off hoping that someone from WD is reading this list and will notice 
this in case my effort with tech support fails.

Tvrtko
_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

