Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZEULkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZEULkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZEULkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:40:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64518 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZEULkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <m1zld6u4u7.fsf@fess.ebiederm.org>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> 
	<4A14E836.5090302@kernel.org> <ac3eb2510905210306o48bdf4c8rf7459b35aa521998@mail.gmail.com> 
	<m1zld6u4u7.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 21 May 2009 13:40:04 +0200
Message-ID: <ac3eb2510905210440p14a09d0r1f9a31bd0ecbb9b6@mail.gmail.com>
Subject: Re: [PATCH 01/20] sysfs: Implement sysfs_rename_link
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 12:29, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Kay Sievers <kay.sievers@vrfy.org> writes:

>> The target string is composed on-demand, and it always points to the
>> same kobject and *targ is not needed, right?
>>
>> Can't we just change the name of the link, instead of removing and
>> re-creating the entire thing, and all these issues go away?
>
> Good point.  It looks like I can generalize sysfs_mv_dir into simply
> being sysfs_rename.  All of the existing logic looks like it can handle
> that.  I will look at doing an incremental patch for that.

Nice, would be great, if that can be made working. It would be much
better than the current logic, and there would be no ordering problem,
like Tejun mentioned, to solve anymore.

As we don't need to change the target for link, maybe:
  sysfs_rename_file(kobj_parent, old_name, new_name);
that can act on symlinks and regular files would be useful?

Thanks,
Kay
