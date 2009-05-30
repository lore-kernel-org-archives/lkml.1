Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbZE3OAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbZE3OAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758308AbZE3OAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:00:10 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:62463 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZE3OAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:00:09 -0400
MIME-Version: 1.0
In-Reply-To: <m1d49qoi1o.fsf@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org> <1243551665-23596-4-git-send-email-ebiederm@xmission.com> 
	<4A1FA777.3040200@kernel.org> <m1zlcvdf7j.fsf@fess.ebiederm.org> 
	<4A210DEF.2030203@kernel.org> <m1d49qoi1o.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 30 May 2009 15:59:55 +0200
Message-ID: <ac3eb2510905300659p829b723hbbae72b49265d3ff@mail.gmail.com>
Subject: Re: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 15:07, Eric W. Biederman <ebiederm@xmission.com> wrote:

> My take is simply that a correct user has to wait until no one else
> can find the kobject before calling kobject_del.  At which point
> races are impossible, and it doesn't matter if sysfs_mutex is held
> across the entire operation.

We have circular references between kobjects in some "advanced" users.
We can not break the circle without calling _del() on one of the
objects involved, but at that time all of the objects are still
referenced by another object. Only a _del() will break the circle, and
result in a release of the objects involved. Not sure how that would
behave with this change?

Thanks,
Kay
