Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0CCBaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 20:30:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:44347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab0CCBaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 20:30:04 -0500
Message-ID: <4B8DBE37.3000806@kernel.org>
Date: Wed, 03 Mar 2010 10:41:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 44/62] sysfs: Use one lockdep class per sysfs attribute.
References: <20100302230933.GA32287@kroah.com> <1267572541-410-44-git-send-email-gregkh@suse.de>
In-Reply-To: <1267572541-410-44-git-send-email-gregkh@suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 01:30:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 08:28 AM, Greg Kroah-Hartman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Acknowledge that the logical sysfs rwsem has one instance per
> sysfs attribute with different locking depencencies for different
> attributes.
> 
> There is a sysfs idiom where writing to one sysfs file causes the
> addition or removal of other sysfs files.   Lumping all of the
> sysfs attributes together in one lock class causes lockdep to
> generate lots of false positives.
> 
> This introduces the requirement that non-static sysfs attributes
> need to be initialized with sysfs_attr_init or sysfs_bin_attr_init.
> Strictly speaking this requirement only exists when lockdep is
> enabled, and when lockdep is enabled we get a bit fat warning
> if this requirement is not met.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Tejun Heo <tj@kernel.org> but it would be nice if when and
how attr->key is set for each case and how it's supposed to trigger
big fat warning in the code.  It's a bit difficult to follow
currently.

-- 
tejun
