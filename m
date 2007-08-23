Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbXHWD4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbXHWD4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXHWD4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:56:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54287 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbXHWD4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:56:12 -0400
Date: Thu, 23 Aug 2007 09:26:29 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Jay Lan <jlan@sgi.com>
Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070823035629.GB365@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070802112852.GA7054@in.ibm.com> <31687.1186113947@kao2.melbourne.sgi.com> <20070805110746.GA12540@in.ibm.com> <46C1691E.7090708@ah.jp.nec.com> <20070814083710.GA14538@suse.de> <20070814132454.GA8293@in.ibm.com> <46C4184B.5030303@ah.jp.nec.com> <20070817105630.GA18167@in.ibm.com> <46CAE627.7070908@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CAE627.7070908@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 06:18:31AM -0700, Jay Lan wrote:
[..]
> >>> Now user will be able to view all the die_chain users through sysfs and
> >>> be able to modify the order in which these should run by modifying their
> >>> priority. Hence all the RAS tools can co-exist.
> >> This is my image of your proposal.
> >>
> >> - Print current order
> >>
> >> # cat /sys/class/misc/debug/panic_notifier_list
> >> priority   name
> >> 1          IPMI
> >> 2          watchdog
> >> 3          Kdb
> >> 4          Kdump
> >>
> > 
> > I think Bernhard's suggestion looks better here. I noticed that 
> > /sys/kernel/debug is already present. So how about following.
> > 
> > /sys/kernel/debug/kdump/priority
> > /sys/kernel/debug/kdb/priority
> > /sys/kernel/debug/IPMI/priority
> 
> Why separate priority files is better than a central file?
> At least i think you get a grand picture of priority being
> defined for all parties with a central file?
> 

I thought of couple of reasons.
- A very different syntax to modify the priority.
- Separate directories allow easy future extensions in terms of more
  files. For example, putting a small "description" file in each dir
  where each registered user can specify what does it do.

But I agree that a single file is good for consolidated view. As bernhard
suggested, may be we should also implement a read only file where one
will get a consolidated view.

> What do we decide priority if more than one component has
> the same priority value?
> 

I think first come first serve would be appropriate in this case instead of
returning -EINVAL.

Thanks
Vivek
