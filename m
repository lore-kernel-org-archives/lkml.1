Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZEWUr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZEWUr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZEWUrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:47:49 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:46185 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZEWUrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:47:48 -0400
MIME-Version: 1.0
In-Reply-To: <m1prdzh97x.fsf@fess.ebiederm.org>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <m1k54a7w2x.fsf@fess.ebiederm.org> 
	<4A15046A.10106@kernel.org> <m1octm287f.fsf@fess.ebiederm.org> 
	<4A1512E2.2040505@kernel.org> <m1vdnuyftb.fsf@fess.ebiederm.org> 
	<4A151ECE.50800@kernel.org> <m17i08jpk8.fsf@fess.ebiederm.org> 
	<ac3eb2510905230435n20dc376cw95e10eb2cb0cfecb@mail.gmail.com> 
	<m1prdzh97x.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 23 May 2009 22:46:27 +0200
Message-ID: <ac3eb2510905231346n6f7ba736we0c4f9bce8e5e59f@mail.gmail.com>
Subject: Re: [PATCH 04/20] sysfs: Handle the general case of removing of 
	directories with subdirectories
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 22:09, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Kay Sievers <kay.sievers@vrfy.org> writes:
>> What's the problem in /sys/dev/? There are just a bunch of symlinks,
>> one for every device with a dev_t, and all in flat directories, and no
>> directory to remove.
>
> device_shutdown called during reboot removes /sys/dev/block and /sys/dev/char.
> The current sysfs_remove_dir (because it empties directories)
> removes all of those symlinks.
>
> The problem is that it is the device objects for each individual
> device that owns those symlinks, and normally removes those symlinks.
>
> Which means that in theory we could have double deletion going on.
>
> In practice today it doesn't matter because this is at reboot.
>
> And as far as that goes it is wrong to remove anything from sysfs during
> device_shutdown so the fix is just to not call kobject_put there.

Yes, that's just a bug. These directories should never be removed.

Thanks,
Kay
