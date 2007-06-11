Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbXFKWqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbXFKWqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbXFKWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:46:12 -0400
Received: from rtr.ca ([64.26.128.89]:2011 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbXFKWqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:46:11 -0400
Message-ID: <466DD0B1.7020802@rtr.ca>
Date: Mon, 11 Jun 2007 18:46:09 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Tweedie <sct@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
References: <46680BB8.50404@rtr.ca> <20070607084142.42583639.akpm@linux-foundation.org> <46682E4E.1070303@redhat.com> <46687C05.1080408@rtr.ca> <20070611110547.GA26561@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20070611110547.GA26561@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>> Chuck Ebbert wrote:
>>> On 06/07/2007 11:41 AM, Andrew Morton wrote:
>>>>>   mount /var/lib/mythtv -oremount,ro
>>>>>   sync
>>>>>   umount /var/lib/mythtv
>>>> Did this succeed?  If the application is still truncating that file, the
>>>> umount should have failed.
>>> Shouldn't sync should wait for truncate to finish?
>> The part that gets me here, and that others might be missing,
>> is that we are not waiting for ftruncate at this point.
>>
>> We're waiting for unlink.  The application that was doing ftruncate
>> in tiny little doses has been sent a kill-9 signal, so what should
>> be happening now (confirmed by disk activity LEDs) is the file should
>> just be getting deleted the same as if we did "rm bigfile" on it.
>   But if that app has been waiting in D state, kill -9 does nothing to it
> until it wakes up, doesn't it? So fd's are still open and umount fails.

Yeah, except the task is in Zombie state at this point.
But the umount does fail properly, so I no longer complain about that.

Cheers
