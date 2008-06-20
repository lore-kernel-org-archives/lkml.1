Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYFTDlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYFTDlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 23:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYFTDlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 23:41:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46463 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYFTDlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 23:41:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cedric Le Goater <clg@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>
References: <20071128163728.177495768@fr.ibm.com>
	<m11w2syfmk.fsf@frodo.ebiederm.org>
Date: Thu, 19 Jun 2008 20:39:44 -0700
In-Reply-To: <m11w2syfmk.fsf@frodo.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 19 Jun 2008 20:00:51 -0700")
Message-ID: <m1ve04vkov.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cedric Le Goater <clg@fr.ibm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Linux Containers <containers@lists.osdl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Emelianov
	<xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch -mm 0/4] mqueue namespace
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> One way to fix that is to add a hidden directory to the mnt namespace.
> Where magic in kernel filesystems can be mounted.  Only visible
> with a magic openat flag.  Then:
>
> fd = openat(AT_FDKERN, ".", O_DIRECTORY)
> fchdir(fd);
> umount("./mqueue", MNT_DETACH);
> mount(("none", "./mqueue", "mqueue", 0, NULL);
>
> Would unshare the mqueue namespace.
>
> Implemented for plan9 this would solve a problem of how do you get
> access to all of it's special filesystems.  As only bind mounts
> and remote filesystem mounts are available.  For linux thinking about
> it might shake the conversation up a bit.

Thinking about this some more.  What is especially attractive if we do
all namespaces this way is that it solves two lurking problems.
1) How do you keep a namespace around without a process in it.
2) How do you enter a container.

If we could land the namespaces in the filesystem we could easily
persist them past the point where a process is present in one if we so
choose.

Entering a container would be a matter of replacing your current
namespaces mounts with namespace mounts take from the filesystem.

I expect performance would degrade in practice, but it is tempting
to implement it and run a benchmark and see if we can measure anything.

Eric
