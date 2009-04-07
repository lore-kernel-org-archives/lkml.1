Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbZDGQCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbZDGQCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbZDGQCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:02:19 -0400
Received: from mailer1.greenhost.nl ([195.190.28.77]:40580 "EHLO
	mailer1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758855AbZDGQCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:02:18 -0400
X-Greylist: delayed 1313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 12:02:17 EDT
Message-ID: <b7bb17e28bad417d37765814626bb886.squirrel@webmail.greenhost.nl>
In-Reply-To: <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
    <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
    <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
    <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
    <20090404135719.GA9812@mit
    <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
Date: Tue, 7 Apr 2009 17:39:30 +0200 (CEST)
Subject: Re: [GIT PULL] Ext3 latency fixes
From: "Indan Zupancic" <indan@nul.nu>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Theodore Tso" <tytso@mit.edu>,
       "Linux Kernel Developers List" <linux-kernel@vger.kernel.org>,
       "Ext4 Developers List" <linux-ext4@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, April 4, 2009 17:57, Linus Torvalds wrote:
>
> On Sat, 4 Apr 2009, Jens Axboe wrote:
>>
>> Big nack on this patch. Ted, this is EXACTLY where I told you we saw big
>> write regressions (sqlite performance drops by a factor of 4-5). Do a
>> git log on fs/buffer.c and see the original patch (which does what your
>> patch does) and the later revert. No idea why you are now suggestion
>> making that exact change?!
>
> Jens, if I can re-create the 'fsync' times (I haven't yet), then the
> default scheduler _will_ be switched to AS.

http://bugzilla.kernel.org/show_bug.cgi?id=5900

I can try it with a different fs, kernel or machine as well.

To me it seems this stuff is way more tricky than it should be, with
all the interaction between fs, vm, io schedulers and hardware.
Perhaps there's a need for one sophisticated io scheduler that gets
enough information from the rest to make the right decisions. Sync
or not sync isn't enough info.


