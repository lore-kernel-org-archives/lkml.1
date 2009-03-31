Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbZCaOZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbZCaOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZCaOZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:25:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZCaOZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:25:47 -0400
Date: Tue, 31 Mar 2009 16:25:33 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, riel@redhat.com, jeremy@goop.org,
       mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-ID: <20090331142533.GR9137@random.random>
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com> <1238457560-7613-2-git-send-email-ieidus@redhat.com> <1238457560-7613-3-git-send-email-ieidus@redhat.com> <1238457560-7613-4-git-send-email-ieidus@redhat.com> <1238457560-7613-5-git-send-email-ieidus@redhat.com> <49D17C04.9070307@codemonkey.ws> <49D20B63.8020709@redhat.com> <49D21B33.4070406@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D21B33.4070406@codemonkey.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 08:31:31AM -0500, Anthony Liguori wrote:
> You could drop KSM_START_STOP_KTHREAD and KSM_GET_INFO_KTHREAD altogether, 
> and introduce a sysfs hierarchy:
>
> /sysfs/<some/path>/ksm/{enable,pages_to_scan,sleep_time}

Introducing a sysfs hierarchy sounds a bit of overkill.

> the ability to disable KSM.  That seems like a security concern to me since 
> registering a memory region ought to be an unprivileged action whereas 
> enabling/disabling KSM ought to be a privileged action.

sysfs files would then only be writeable by admin, so if we want to
allow only admin to start/stop/tune ksm it'd be enough to plug an
admin capability check in the ioctl to provide equivalent permissions.

I could imagine converting the enable/pages_to_scan/sleep_time to
module params and tweaking them through /sys/module/ksm/parameters,
but for "enable" to work that way, we'd need to intercept the write so
we can at least weakup the kksmd daemon, which doesn't seem possible
with /sys/module/ksm/parameters, so in the end if we stick to the
ioctl for registering regions, it seems simpler to use it for
start/stop/tune too.
