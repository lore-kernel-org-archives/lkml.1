Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZKDGmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZKDGmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZKDGmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:42:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56929 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZKDGmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:42:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Nov 2009 15:40:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org,
       Jan Safranek <jsafrane@redhat.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-Id: <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091104063005.GC3560@balbir.in.ibm.com>
References: <20091104063005.GC3560@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 12:00:05 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Hi, All,
> 
> We've been having a discussion as to what would be the right place to
> mount the cgroup filesystem. Jan has been proactively looking into
> this. The FHS has no recommendation since cgroup filesystem came in
> much later.
> 
> The options are
> 
> 1. /dev/cgroup
> 2. /cgroup
> 3. Some place under /sys
> 
> The problem with (2) is that it is quite non-standard and pollutes the
> root directory. (3) requires some basic support to create a directory
> for cgroup under /sys. (1) seems the most obvious choice since cpusets
> were mounted under /dev/cpuset, but /dev is controlled by udev.
> 
> Given the three choices or any other suggestions, is there a general
> preference as to where we can mount it? The goal is to standardize
> the mount point (if possible).
> 
> BTW, the mounting is expected to be done using cgconfigparser present
> in libcgroup.
> 

IMHO, even if anywhere is ok to me, the suggestion should includes the fact
  - Each cgroup subsystem can be mounted independenty from other cgroup.
  - some cgroup (noop) can be mounted multiple times
etc...there are some points which is different from /proc or /sys.
So, we need multiple mount points.

Then, to say my own not-seriously-considered idea, I vote for
 - /cgroup/[HierarchyName]/
rather than /dev/ or /sys or /opt. This sounds straightforward.

If /sys,  /sys/cgroup/[HierarchyName] will be candidate. But considering
users can use arbitarary combination of subsystem, using /sys may require
much work, I think.

Thanks,
-Kame

