Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYJGLEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYJGLEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYJGLEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:04:31 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:41241 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752781AbYJGLEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:04:31 -0400
Message-ID: <48EB4236.1060100@linux.vnet.ibm.com>
Date: Tue, 07 Oct 2008 16:34:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Michael Rubin <mrubin@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, dave@linux.vnet.ibm.com,
       chlunde@ping.uio.no, dpshah@google.com, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, agk@sourceware.org, m.innocenti@cineca.it,
       s-uchida@ap.jp.nec.com, ryov@valinux.co.jp, matt@bluehost.com,
       dradford@bluehost.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
References: <1221232192-13553-1-git-send-email-righi.andrea@gmail.com> <20080912131816.e0cfac7a.akpm@linux-foundation.org> <532480950809221641y3471267esff82a14be8056586@mail.gmail.com>
In-Reply-To: <532480950809221641y3471267esff82a14be8056586@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Rubin wrote:
> On Fri, Sep 12, 2008 at 1:18 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> One thing to think about please: Michael Rubin is hitting problems with
>> the existing /proc/sys/vm/dirty-ratio.  Its present granularity of 1%
>> is just too coarse for really large machines, and as
>> memory-size/disk-speed ratios continue to increase, this will just get
>> worse.
> 
> Re-sending since I top-posted before. Never again. Also adding more
> thoughts on a byte based interface.
> 
> Currently the problem we are hitting is that we cannot specify pdflush
> to have background limits less than 1% of memory. I am currently
> finishing up a patch right now that adds a dirty_ratio_millis
> interface.  I hope to submit the patch to LKML by the end of the week.
> 
> The idea is that we don't want to break backwards compatibility and we
> also don't want to have two conflicting knobs in the sysctl or
> /proc/sys/vm/ space. I thought adding a new knob for those who want to
> specify finer grained functionality was a compromise. So the patch has
> a vm_dirty_ratio and a vm_dirty_ratio_millis interface. The first to
> specify 0-100% and the second to specify .0 to .999%.
> 
> So to represent 0.125% of RAM we set
> vm_dirty_ratio = 0
> vm_dirty_ratio_millis = 125
> 
> The same for the background_ratio.
> 
> I would also prefer using a bytes interface but I am not sure how to
> offer that without  either removing the legacy interface of the ratios
> or by offering a concurrent interface that might be confusing such as
> when users are looking at the old one and not aware of a new one.
> 

Just provide a vm_dirty_ration_in_bytes interface and keep it in sync with
vm_dirty_ratio (they are just two representations of the same internal value)
and for higher resolution propose that users use the bytes interface.



-- 
	Balbir
