Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYGBQvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYGBQvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYGBQvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:51:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48426 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYGBQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:51:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.002784342@theryb.frec.bull.fr>
	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>
	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>
	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>
	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>
	<486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org>
	<486B060C.7030607@gmail.com>
Date: Wed, 02 Jul 2008 09:49:33 -0700
In-Reply-To: <486B060C.7030607@gmail.com> (Tejun Heo's message of "Wed, 02 Jul
	2008 13:37:32 +0900")
Message-ID: <m14p78s02q.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <htejun@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 06/11] sysfs: Implement sysfs tagged directory support.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Is it difficult to just export it via kobject and device layer?

Well gregkh thought it wasn't a good idea last time I tried exploring
that.

> If
> changing the default function is too much of a hassle (and I'm sure it
> would be), just add an extended version which takes @tag.  The current
> implementation feels like it tried too hard to not add intermediate
> interfaces and ended up shooting outside from the innermost layer.

It tried for something that was simple to use and that worked.

Also the way things work.  I have to use all of the intermediate layers
and their calls to various functions.  So just passing a parameter through
doesn't work to well.

It looks to me like the clean solution is move kobject_tag into
kobj_type, and have it call some higher level function.

We also need to remove the maintenance disaster that is
kobject_set_name from sysfs_rename_dir.  And push it into
kobject_rename instead.  The error handling is harder in
that case but otherwise we should be in good shape.

>> On the other side I can't pass a tag through from the device layer to
>> the kobject layer.  It isn't a concept the kobject layer supports.
>
> I think it's best to make kobject layer support it.

Assuming Greg will accept it when he sees reasonable patches.

Eric
