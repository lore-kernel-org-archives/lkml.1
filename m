Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYARISb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYARISb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYARISZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:18:25 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33630 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751017AbYARISY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:18:24 -0500
Message-ID: <400644314.11994@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 18 Jan 2008 14:01:14 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andi Kleen <andi@firstfloor.org>
Cc: Michael Rubin <mrubin@google.com>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
References: <20080115080921.70E3810653@localhost> <400562938.07583@ustc.edu.cn> <532480950801171307q4b540ewa3acb6bfbea5dbc8@mail.gmail.com> <400632190.14601@ustc.edu.cn> <p738x2nbsi2.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p738x2nbsi2.fsf@bingen.suse.de>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JFkHy-0001jR-VD@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 06:41:09AM +0100, Andi Kleen wrote:
> Fengguang Wu <wfg@mail.ustc.edu.cn> writes:
> >
> > Suppose we want to grant longer expiration window for temp files,
> > adding a new list named s_dirty_tmpfile would be a handy solution.
> 
> How would the kernel know that a file is a tmp file?

No idea - but it makes a good example ;-)

But for those making different filesystems for /tmp, /var, /data etc, 
per-superblock expiration parameters may help.

> > So the question is: should we need more than 3 QoS classes?
> 
> [just a random idea; i have not worked out all the implications]
> 
> Would it be possible to derive a writeback apriority from the ionice
> level of the process originating the IO? e.g. we have long standing
> problems that background jobs even when niced and can cause
> significant slow downs to foreground processes by starving IO 
> and pushing out pages. ionice was supposed to help with that
> but in practice it does not seem to have helped too much and I suspect
> it needs more prioritization higher up the VM food chain. Adding
> such priorities to writeback would seem like a step in the right
> direction, although it would of course not solve the problem
> completely.

Good idea. Michael may well be considering similar interfaces :-)

