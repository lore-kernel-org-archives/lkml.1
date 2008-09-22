Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYIVXl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYIVXl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYIVXlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:41:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:8923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbYIVXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:41:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=Nj17dUZnYLCcjcMbG31mGyIH5s68q+G6TUabu6qVVG2cp98vLskJYU3fPGcMbOvWu
	qreG0/FUFpSbQQTxi5a+A==
Message-ID: <532480950809221641y3471267esff82a14be8056586@mail.gmail.com>
Date: Mon, 22 Sep 2008 16:41:33 -0700
From: "Michael Rubin" <mrubin@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
Cc: "Andrea Righi" <righi.andrea@gmail.com>, balbir@linux.vnet.ibm.com,
       menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       dave@linux.vnet.ibm.com, chlunde@ping.uio.no, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, agk@sourceware.org,
       m.innocenti@cineca.it, s-uchida@ap.jp.nec.com, ryov@valinux.co.jp,
       matt@bluehost.com, dradford@bluehost.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080912131816.e0cfac7a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221232192-13553-1-git-send-email-righi.andrea@gmail.com>
	 <20080912131816.e0cfac7a.akpm@linux-foundation.org>
X-GMailtapped-By: 172.25.146.75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 1:18 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> One thing to think about please: Michael Rubin is hitting problems with
> the existing /proc/sys/vm/dirty-ratio.  Its present granularity of 1%
> is just too coarse for really large machines, and as
> memory-size/disk-speed ratios continue to increase, this will just get
> worse.

Re-sending since I top-posted before. Never again. Also adding more
thoughts on a byte based interface.

Currently the problem we are hitting is that we cannot specify pdflush
to have background limits less than 1% of memory. I am currently
finishing up a patch right now that adds a dirty_ratio_millis
interface.  I hope to submit the patch to LKML by the end of the week.

The idea is that we don't want to break backwards compatibility and we
also don't want to have two conflicting knobs in the sysctl or
/proc/sys/vm/ space. I thought adding a new knob for those who want to
specify finer grained functionality was a compromise. So the patch has
a vm_dirty_ratio and a vm_dirty_ratio_millis interface. The first to
specify 0-100% and the second to specify .0 to .999%.

So to represent 0.125% of RAM we set
vm_dirty_ratio = 0
vm_dirty_ratio_millis = 125

The same for the background_ratio.

I would also prefer using a bytes interface but I am not sure how to
offer that without  either removing the legacy interface of the ratios
or by offering a concurrent interface that might be confusing such as
when users are looking at the old one and not aware of a new one.

Any feedback?

mrubin
