Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYIWRvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYIWRvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYIWRve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:51:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54925 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYIWRvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:51:33 -0400
Date: Wed, 24 Sep 2008 02:48:29 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Michael Rubin" <mrubin@google.com>
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Andrew Morton" <akpm@linux-foundation.org>, dradford@bluehost.com,
       m.innocenti@cineca.it, fernando@oss.ntt.co.jp,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       agk@sourceware.org, matt@bluehost.com, menage@google.com,
       Andrea Righi <righi.andrea@gmail.com>, eric.rannaud@gmail.com,
       balbir@linux.vnet.ibm.com
In-Reply-To: <532480950809221641y3471267esff82a14be8056586@mail.gmail.com>
References: <20080912131816.e0cfac7a.akpm@linux-foundation.org> <532480950809221641y3471267esff82a14be8056586@mail.gmail.com>
Message-Id: <20080924024437.DC21.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Why vm_dirty_ratio = 0.125 is wrong?
it is hardly for parser maker, but it have nicer user experience.

> 
> I would also prefer using a bytes interface but I am not sure how to
> offer that without  either removing the legacy interface of the ratios
> or by offering a concurrent interface that might be confusing such as
> when users are looking at the old one and not aware of a new one.
> 
> Any feedback?

Sure.
We don't have any motivation of its interface change.



