Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbZEUKGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbZEUKGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZEUKGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:06:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54016 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZEUKGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:06:39 -0400
MIME-Version: 1.0
In-Reply-To: <4A14E836.5090302@kernel.org>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> 
	<4A14E836.5090302@kernel.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 21 May 2009 12:06:18 +0200
Message-ID: <ac3eb2510905210306o48bdf4c8rf7459b35aa521998@mail.gmail.com>
Subject: Re: [PATCH 01/20] sysfs: Implement sysfs_rename_link
To: Tejun Heo <tj@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
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

On Thu, May 21, 2009 at 07:35, Tejun Heo <tj@kernel.org> wrote:
> Eric W. Biederman wrote:
>> +int sysfs_rename_link(struct kobject *kobj, struct kobject *targ,
>> +                     const char *old, const char *new)
>> +{
>> +     sysfs_remove_link(kobj, old);
>> +     return sysfs_create_link(kobj, targ, new);
>> +}
>> +
>
> Removal and creation are done in the reverse order compared to the one
> used in device rename.  The important difference is that previously
> failed operation was noop whereas it now would remove the current
> link.  I think the old order is correct.

The target string is composed on-demand, and it always points to the
same kobject and *targ is not needed, right?

Can't we just change the name of the link, instead of removing and
re-creating the entire thing, and all these issues go away?

Thanks,
Kay
