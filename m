Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZFDABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZFDABU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZFDABN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:01:13 -0400
Received: from kroah.org ([198.145.64.141]:58449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZFDABN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:01:13 -0400
Date: Wed, 3 Jun 2009 16:53:22 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/26] sysfs: sysfs_remove_dir stop checking for bogus
	cases.
Message-ID: <20090603235322.GA19375@kroah.com>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org> <1243628376-22905-4-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243628376-22905-4-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 01:19:14PM -0700, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> kobj->sd can not be NULL in sysfs_remove_dir.
> 
> sysfs_remove_dir is only called from kobject_add (to clean up after failure)
> and from kobject_del at the end of a kobject's life.  In both cases kobject_add
> has already called sysfs_create_dir successfully.  The only writers of
> kobj->sd are sysfs_create_dir on sucess and sysfs_remove_dir when it clears
> the kobj just before deleting the directory.
> 
> Which means at the time sysfs_remove_dir is called kobj->sd will be
> valid.

Yeah, we would hope so.

But as we have been forced to add many checks like this into the driver
core to handle those "no one could ever call this" type problems that
have been springing up over time, I am hesitant to remove this check.

Why do you want to remove it, what is the problem here you are trying to
solve?

thanks,

greg k-h
