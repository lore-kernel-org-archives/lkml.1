Return-Path: <linux-kernel-owner+w=401wt.eu-S1762827AbYARPi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762827AbYARPi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762334AbYARPhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:37:13 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:40911 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762339AbYARPhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:37:11 -0500
Message-ID: <4790C50F.2080704@emc.com>
Date: Fri, 18 Jan 2008 10:26:07 -0500
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Bryan Henderson <hbryan@us.ibm.com>,
       Ric Wheeler <ric@emc.com>, Al Boldi <a1426z@gawab.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Daniel Phillips <phillips@google.com>, Rik van Riel <riel@redhat.com>,
       Valerie Henson <val.henson@gmail.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
References: <478FE22D.9030907@emc.com> <OF3F61F02C.985CCACC-ON882573D4.0001DCF2-882573D4.0002E9F5@us.ibm.com> <20080118142308.GD12796@mit.edu>
In-Reply-To: <20080118142308.GD12796@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Jan 17, 2008 at 04:31:48PM -0800, Bryan Henderson wrote:
>> But I heard some years ago from a disk drive engineer that that is a myth 
>> just like the rotational energy thing.  I added that to the discussion, 
>> but admitted that I haven't actually seen a disk drive write a partial 
>> sector.
> 
> Well, it would be impossible or at least very hard to see that in
> practice, right?  My understanding is that drives do sector-level
> checksums, so if there was a partially written sector, the checksum
> would be bogus and the drive would return an error when you tried to
> read from it.

There is extensive per sector error correction on each sector written. 
What you would see in this case (or many, many other possible ways 
drives can corrupt media) is a "media error" on the next read.

You would never get back the partially written contents of that sector 
at the host.

Having our tools (fsck especially) be resilient in the face of media 
errors is really critical. Although I don't think the scenario of a 
partially written sector is common, media errors in general are common 
and can develop over time.

> 
>> Ted brought up the separate issue of the host sending garbage to the disk 
>> device because its own power is failing at the same time, which makes the 
>> integrity at the disk level moot (or even undesirable, as you'd rather 
>> write a bad sector than a good one with the wrong data).
> 
> Yep, exactly.  It would be interesting to see if this happens on
> modern hardware; all of the evidence I've had for this is years old at
> this point.  
> 
> 							- Ted
> 

See the NetApp paper from Sigmetrics 2007 for some interesting analysis...


ric
