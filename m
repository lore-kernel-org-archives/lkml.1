Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYGCMbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYGCMbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbYGCMbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:31:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56803 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219AbYGCMbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:31:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Thery <benjamin.thery@bull.net>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.002784342@theryb.frec.bull.fr>
	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>
	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>
	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>
	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>
	<486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org>
	<486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>
	<486C4515.1070007@gmail.com> <m1hcb7o8lv.fsf@frodo.ebiederm.org>
	<486CB051.5000507@fr.ibm.com>
Date: Thu, 03 Jul 2008 05:27:01 -0700
In-Reply-To: <486CB051.5000507@fr.ibm.com> (Daniel Lezcano's message of "Thu,
	03 Jul 2008 12:56:17 +0200")
Message-ID: <m14p77m9uy.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Lezcano <dlezcano@fr.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0052]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 06/11] sysfs: Implement sysfs tagged directory support.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano <dlezcano@fr.ibm.com> writes:

> The kobject events are sent through a netlink message which is not currently per
> network namespace. Shouldn't be useful to have a way to retrieve from the
> kobject the network namespace or the uevent socket associated with it ? IMHO
> having idr in the kobject + netns pointer associated may help to handle the
> sysfs isolation and makes the uevent per namespace trivial, no ?

Grumble.  I have been conveniently been forgetting about that socket.
Similarly we have the user mode helpers to deal with.

For this conversation there is a simple answer.  All of that is in the
kobject layer, and works even when you compile sysfs out of your kernel.
Therefore it is a separate problem.  And sysfs idr tags have nothing
to do with it.

It is most definitely something we need to come back to.  I bet there
are some interesting interactions when you have multiple network devices
with the same name generating events.

Eric








