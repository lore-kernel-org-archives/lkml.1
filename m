Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbZE3NVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbZE3NVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbZE3NVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:21:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:48208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626AbZE3NVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:21:03 -0400
Message-ID: <4A21329A.10202@kernel.org>
Date: Sat, 30 May 2009 22:20:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>	<1243551665-23596-4-git-send-email-ebiederm@xmission.com>	<4A1FA777.3040200@kernel.org> <m1zlcvdf7j.fsf@fess.ebiederm.org>	<4A210DEF.2030203@kernel.org> <m1d49qoi1o.fsf@fess.ebiederm.org>
In-Reply-To: <m1d49qoi1o.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 May 2009 13:20:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
> I guess we are going to have to disagree on this one.

Yeap, seems like it.

> My take is simply that a correct user has to wait until no one else
> can find the kobject before calling kobject_del.  At which point
> races are impossible, and it doesn't matter if sysfs_mutex is held
> across the entire operation.

This one also is a matter of degree.  Way back when users could crash
sysfs reliably from userland, the sysfs code had a lot of assumptions
about object lifetime and synchronizaion which even the sysfs code
itself didn't really follow leading to fragility.  My focus while
restructuring the code was to make the code behave as expected by the
usual conventions.  It could be that I'm a bit paranoid about this,
but in general I really don't like when low level code doesn't do its
due diligence to save several hours of effort to implement clean
semantics, but again there's nothing wrong with your due and my due
being different.

I guess I'll have to pass the buck to Greg again with my rather strong
NACK.

> For the long term I still intend to kill __sysfs_remove_dir.  Just
> not in this patch series.

Yeah, sysfs code is in the middle of two sane ways.  sysfs either has
to deal with children creation/removal including atomicity of the
operations or it should force its users to do so.  I prefer the former
but any would be better than the current situation.

Thanks.

-- 
tejun
