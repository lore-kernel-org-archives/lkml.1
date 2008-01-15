Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYAOBGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYAOBGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYAOBF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:05:56 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:18655 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYAOBFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:05:55 -0500
Message-ID: <478C06B4.6050708@emc.com>
Date: Mon, 14 Jan 2008 20:04:52 -0500
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>,
       Valerie Henson <val.henson@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFD] Incremental fsck
References: <200801090022.55589.a1426z@gawab.com> <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu> <20080113171916.GB4132@ucw.cz>
In-Reply-To: <20080113171916.GB4132@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=1%, Reasons='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2008-01-12 09:51:40, Theodore Tso wrote:
>> On Wed, Jan 09, 2008 at 02:52:14PM +0300, Al Boldi wrote:
>>> Ok, but let's look at this a bit more opportunistic / optimistic.
>>>
>>> Even after a black-out shutdown, the corruption is pretty minimal, using 
>>> ext3fs at least.
>>>
>> After a unclean shutdown, assuming you have decent hardware that
>> doesn't lie about when blocks hit iron oxide, you shouldn't have any
>> corruption at all.  If you have crappy hardware, then all bets are off....
> 
> What hardware is crappy here. Lets say... internal hdd in thinkpad
> x60?
> 
> What are ext3 expectations of disk (is there doc somewhere)? For
> example... if disk does not lie, but powerfail during write damages
> the sector -- is ext3 still going to work properly?
> 
> If disk does not lie, but powerfail during write may cause random
> numbers to be returned on read -- can fsck handle that?
> 
> What abou disk that kills 5 sectors around sector being written during
> powerfail; can ext3 survive that?
> 
> 							Pavel
> 

I think that you have to keep in mind the way disk (and other media) 
fail. You can get media failures after a successful write or errors that 
pop up as the media ages.

Not to mention the way most people run with write cache enabled and no 
write barriers enabled - a sure recipe for corruption.

Of course, there are always software errors to introduce corruption even 
when we get everything else right ;-)

 From what I see, media errors are the number one cause of corruption in 
file systems. It is critical that fsck (and any other tools) continue 
after an IO error since they are fairly common (just assume that sector 
is lost and do your best as you continue on).

ric

