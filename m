Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbYGJTC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbYGJTC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760181AbYGJTCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:02:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43591 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759640AbYGJTCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:02:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Kirill Korotaev <dev@parallels.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>
References: <20080418054459.891481000@bull.net>
	<20080422193612.GA15835@martell.zuzino.mipt.ru>
	<1208890580.17117.14.camel@nimitz.home.sr71.net>
	<20080422210130.GA15937@martell.zuzino.mipt.ru>
	<1208904967.17117.51.camel@nimitz.home.sr71.net>
	<480ED9D5.1010906@parallels.com> <480FE037.2010302@cs.columbia.edu>
	<m1y74a7b4w.fsf@frodo.ebiederm.org> <1215709949.9398.15.camel@nimitz>
	<20080710173246.GA1857@us.ibm.com>
Date: Thu, 10 Jul 2008 11:55:34 -0700
In-Reply-To: <20080710173246.GA1857@us.ibm.com> (Serge E. Hallyn's message of
	"Thu, 10 Jul 2008 12:32:46 -0500")
Message-ID: <m163rd1sd5.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2616]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation with a specified id)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

>> So, the checkpoint-as-a-corefile idea sounds good to me, but it
>> definitely leaves a lot of questions about exactly how we'll need to do
>> the restore.
>
> Talking with Dave over irc, I kind of liked the idea of creating a new
> fs/binfmt_cr.c that executes a checkpoint-as-a-coredump file.
>
> One thing I do not like about the checkpoint-as-coredump is that it begs
> us to dump all memory out into the file.  Our plan/hope was to save
> ourselves from writing out most memory by:
>
> 	1. associating a separate swapfile with each container
> 	2. doing a swapfile snapshot at each checkpoint
> 	3. dumping the pte entries (/proc/self/)
>
> If we do checkpoint-as-a-coredump, then we need userspace to coordinate
> a kernel-generated coredump with a user-generated (?) swapfile snapshot.
> But I guess we figure that out later.

Well it is a matter of which VMAs you dump.  For things that are file backed
you need to dump them.

I don't know that even a binfmt for per process level checkpoints is sufficient
but I do know having something of that granularity looks much easier.  Otherwise
it takes a bazillian little syscalls to do things no one else is interested in doing.

Eric
