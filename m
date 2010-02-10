Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0BJRvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:51:43 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52651 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0BJRvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:51:41 -0500
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Miles Lane <miles.lane@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, akpm@linux-foundation.org
Subject: Re: [RFC Patch] sysfs: add marks for mutable sysfs files
References: <20100210065754.3713.8997.sendpatchset@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Feb 2010 09:51:24 -0800
In-Reply-To: <20100210065754.3713.8997.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Wed\, 10 Feb 2010 01\:54\:27 -0500")
Message-ID: <m1aavh3roj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> NOTE: This patch is only a draft, not ready to be taken.
>
> This fixes all the s_active related bogus lockdep warnings that I received,
> I already tested it, it works fine for cpu hotplug, I/O scheduler switch,
> and suspend.
>
> This patch introduces sever sysfs/kobject interfaces to add mutable
> sysfs files or kobjects, those files could be removed by the kernel
> during some event, e.g. cpu hotplug. All of this kind of sysfs files
> should use these API's, to avoid the deadlock warnings.
>
> I am still not sure if this is the best fix.
>
> Please comment.

mutable as you describe it happens to be the common case, and that
class of files is not free from this class of problem.

Your patch is actively wrong if it solves the i/o scheduler issue,
as those files are in fact mutable by your definition, block devices
are hot pluggable.

Having a special case for permanent sysfs files, that we refuse to
delete would be reasonable, but it certainly does not cover
everything.

Eric
