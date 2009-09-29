Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZI2Aho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZI2Aho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZI2Aho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:37:44 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14653 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZI2Ahn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:37:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=pxQSWcq32w5YLSRvxW036WfVSDoy2KnKswsNdC51uFGKFTZgzjvuAztR261n9pS/c
	hfdbLWaZhkwH3P1Q0SI0A==
MIME-Version: 1.0
In-Reply-To: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
Date: Mon, 28 Sep 2009 17:37:28 -0700
Message-ID: <e98e18940909281737q142c788dpd20b8bdc05dd0eff@mail.gmail.com>
Subject: Re: IO scheduler based IO controller V10
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       yoshikawa.takuya@oss.ntt.co.jp
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
Me, Divyesh, Fernando and Yoshikawa had a chance to have a chat with
Jens about IO controller during Linux Plumbers Conference '09. Jens
expressed his concerns about the size and complexity of the patches. I
believe that is a reasonable concern. We talked about things that
could be done to reduce the size of the patches. The requirement that
the "solution has to work with all IO schedulers" seems like a
secondary concern at this point; and it came out as one thing that can
help to reduce the size of the patch set. Another possibility is to
use a simpler scheduling algorithm e.g. weighted round robin, instead
of BFQ scheduler. BFQ indeed has great properties, but we cannot deny
the fact that it is complex to understand, and might be cumbersome to
maintain. Also, hierarchical scheduling is something that could be
unnecessary in the first set of patches, even though cgroups are
hierarchical in nature.

We are starting from a point where there is no cgroup based IO
scheduling in the kernel. And it is probably not reasonable to satisfy
all IO scheduling related requirements in one patch set. We can start
with something simple, and build on top of that. So a very simple
patch set that enables cgroup based proportional scheduling for CFQ
seems like the way to go at this point.

It would be great if we discuss our plans on the mailing list, so we
can get early feedback from everyone.
