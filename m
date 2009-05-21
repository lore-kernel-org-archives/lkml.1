Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZEUJ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZEUJ3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZEUJ3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:29:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:41164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZEUJ3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:29:06 -0400
Message-ID: <4A151ECE.50800@kernel.org>
Date: Thu, 21 May 2009 18:28:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/20] sysfs: Handle the general case of removing of directories
 with subdirectories
References: <m1bppofm9k.fsf@fess.ebiederm.org>	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>	<1242865694-2100-4-git-send-email-ebiederm@xmission.com>	<4A14F356.3030501@kernel.org> <m1k54a7w2x.fsf@fess.ebiederm.org>	<4A15046A.10106@kernel.org> <m1octm287f.fsf@fess.ebiederm.org>	<4A1512E2.2040505@kernel.org> <m1vdnuyftb.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdnuyftb.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 09:29:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> Well, it can be trivially fixed by checking the removed flag.  The
>> add/rm thing is designed to help additions and removals of multiple
>> nodes at one go and I'd really like to see it working that way.  Any
>> chance you can change code toward that direction?
> 
> Yes.  We definitely need to check the removed flag in sysfs_add_one.
> Regardless of anything else.
> 
> I need to sleep on this but I am inclined to get rid of the rest of
> the complications simply by failing the removal of non-empty
> directories.  Going through the upper layers and making them properly
> responsible for their actions.
> 
> I am afraid friendlier in this circumstance might equate to easier
> to misuse and let code bugs pile up.

I'm going through the latter part of the patchset and the code around
this area gets much simpler there.  Would it be possible to make it
atomic after the simplification?  Requiring recursive deletion from
all the callers is silly and error prone.

Thanks.

-- 
tejun
