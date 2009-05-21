Return-Path: <linux-kernel-owner+w=401wt.eu-S1752167AbZEUFgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbZEUFgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZEUFgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:36:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:38372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZEUFgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:36:06 -0400
Message-ID: <4A14E836.5090302@kernel.org>
Date: Thu, 21 May 2009 14:35:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 01/20] sysfs: Implement sysfs_rename_link
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 05:35:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
> +int sysfs_rename_link(struct kobject *kobj, struct kobject *targ,
> +			const char *old, const char *new)
> +{
> +	sysfs_remove_link(kobj, old);
> +	return sysfs_create_link(kobj, targ, new);
> +}
> +

Removal and creation are done in the reverse order compared to the one
used in device rename.  The important difference is that previously
failed operation was noop whereas it now would remove the current
link.  I think the old order is correct.

Thanks.

-- 
tejun
