Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbYGJTcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbYGJTcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYGJTcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:32:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36377 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYGJTb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:31:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
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
	<20080710173246.GA1857@us.ibm.com> <m163rd1sd5.fsf@frodo.ebiederm.org>
	<1215716794.9398.41.camel@nimitz>
Date: Thu, 10 Jul 2008 12:21:43 -0700
In-Reply-To: <1215716794.9398.41.camel@nimitz> (Dave Hansen's message of "Thu,
	10 Jul 2008 12:06:34 -0700")
Message-ID: <m14p6xy27s.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Hansen <dave@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2306]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation with a specified id)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave@linux.vnet.ibm.com> writes:

> On Thu, 2008-07-10 at 11:55 -0700, Eric W. Biederman wrote:
>> 
>> > If we do checkpoint-as-a-coredump, then we need userspace to coordinate
>> > a kernel-generated coredump with a user-generated (?) swapfile snapshot.
>> > But I guess we figure that out later.
>> 
>> Well it is a matter of which VMAs you dump.  For things that are file backed
>> you need to dump them.

For things that are file backed you DO NOT need to dump them.  (sorry typo).

> Are we talking about the VMA itself, or the memory backing the VMA?

The memory backing the VMA.  We need to store the page protections
that the memory was mapped with as well now that you point it out.  A
VMA is not user space visible, which is why we can arbitrarily split
and merge VMAs.

Eric


