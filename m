Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYIXVOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYIXVOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYIXVOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:14:05 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:46344 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbYIXVOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:14:04 -0400
Message-ID: <48DAAD99.9050904@dgreaves.com>
Date: Wed, 24 Sep 2008 22:14:01 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Sylwester Gruszka <gruszex@gmail.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Broken XFS partition
References: <200809241236.26135.gruszex@gmail.com> <20080924201745.GE24654@1wt.eu>
In-Reply-To: <20080924201745.GE24654@1wt.eu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ed xfs list

Willy Tarreau wrote:
> On Wed, Sep 24, 2008 at 12:36:25PM +0200, Sylwester Gruszka wrote:
>> Hello,
>>
>> I have a problem with XFS partition, it has broken down suddenly. I was doing 
>> no special things, just browsing www and suddenly my PC has restarted, after 
>> that I could not boot by PLD Th linux, after few usual kernel messages I get 
>> some matrix of numbers and it stops.

First thing is why?
If you could boot then you could check the log to see if there was a disk error.

I suggest rebooting to an up-to-date rescue disk (ie 2008 vintage - mainly for
the latest xfs utils) and using smartctl -a to look at the disk state.

Then run smartctl -t long /dev/sdX or some other disk check utility.

This will take a long time to run but should let you see if there are any bad
blocks.

If so then I suggest using ddrescue to recover the disk to a spare/replacement.

Running xfs_repair on a failing disk will likely cause more trouble.

>> I realised that it is broken partition after I tried to repair system, I just 
>> could not mount this partition (using sysrescuecd), 'mount' gave me lots of 
>> weird numbers instead of mounting partition. It only do that way at first try, 
>> the second try always freezes mount program and nothing is happening.
>>
>> Here are some screenshots (mount using SystemRescueCd-1.1.0 so the kernel is 
>> propably 2.6.25.16):
>> http://img397.imageshack.us/my.php?image=dsc01043ko6.jpg
>> http://img179.imageshack.us/my.php?image=dsc01044yj4.jpg
>> http://img158.imageshack.us/my.php?image=dsc01045sr3.jpg
>> http://img221.imageshack.us/my.php?image=dsc01047js4.jpg
>>
>> PLD Linux Th booting:
>> http://img530.imageshack.us/my.php?image=dsc01048mk3.jpg
>>
>> Suse booting:
>> http://img87.imageshack.us/my.php?image=dsc01050as4.jpg
>> Except this warning it boots normal.
>>
>> Now I'm running Suse and I tried xfs_check this partition but xfs_check is 
>> freezing too.

IIRC xfs_check used to be less robust than xfs_repair.

If the disk looks sound then running xfs_repair should help.
Read the manpage. no-modify (-n) may be a good idea first time.

It *may* tell you to remount to replay the log.
You should try this (mounting) but from what you've said it sounds like it won't
work.

You may then try using the -L option which will discard the log/journal. (If
you're nervous about this then wait for expert help - IMHO it's no big deal)

If this fails then you need expert help.

I have had a fair few disk failures over the years and this process is usually
quick and painless :)

David

"Don't worry, you'll be fine; I saw it work in a cartoon once..."
