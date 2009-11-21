Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZKUAHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZKUAHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZKUAHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:07:19 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50121 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZKUAHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:07:18 -0500
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 06/15] sysfs: Fix locking and factor out sysfs_sd_setattr
References: <m1pr7tmqb4.fsf@fess.ebiederm.org>
	<1257665233-12468-6-git-send-email-ebiederm@xmission.com>
	<20091120201355.GA30590@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 20 Nov 2009 16:07:11 -0800
In-Reply-To: <20091120201355.GA30590@kroah.com> (Greg KH's message of "Fri\, 20 Nov 2009 12\:13\:55 -0800")
Message-ID: <m1aayg7nbk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Sat, Nov 07, 2009 at 11:27:04PM -0800, Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Cleanly separate the work that is specific to setting the
>> attributes of a sysfs_dirent from what is needed to update
>> the attributes of a vfs inode.
>> 
>> Additionally grab the sysfs_mutex to keep any nasties from
>> surprising us when updating the sysfs_dirent.
>> 
>> Acked-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
> Due to the extended attr work for sysfs that went into Linus's tree
> recently, this patch doesn't apply at all anymore.

It looks like the issue is the a trivial context conflict  with 
sysfs-mark-a-locally-only-used-function-static.patch

Which marks one of those new functions as static.

Here come the patches 6-15 rebased on top of that.

Eric
