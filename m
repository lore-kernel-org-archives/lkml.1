Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYD2Tjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYD2Tjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYD2Tjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:39:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48442 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYD2Tje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:39:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <20080429171015.473938697@theryb.frec.bull.fr>
	<20080429173621.GA16625@suse.de>
	<20080429180445.GA18110@sergelap.austin.ibm.com>
	<20080429184151.GA19794@suse.de>
Date: Tue, 29 Apr 2008 12:35:28 -0700
In-Reply-To: <20080429184151.GA19794@suse.de> (Greg KH's message of "Tue, 29
	Apr 2008 11:41:51 -0700")
Message-ID: <m1lk2w1mkf.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/10] sysfs tagged directories
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> See the thread from Al starting with:
> 	Date: Mon, 7 Jan 2008 10:24:17 +0000
> 	From: Al Viro <viro@ZenIV.linux.org.uk>
> 	To: "Eric W. Biederman" <ebiederm@xmission.com>
> 	Cc: linux-kernel@vger.kernel.org, htejun@gmail.com,
> 	        linux-fsdevel@vger.kernel.org, gregkh@suse.de
> 	Subject: [RFC] netns / sysfs interaction
> 	Message-ID: <20080107072301.GW27894@ZenIV.linux.org.uk>
>
> He had a lot of questions and objections to this way forward, and I
> share those objections.

If either of you will take those objections and see how they actually
apply to the patches I would be happy.

We are quite successfully using multiple mounts in proc for the
pid namespace with no large issues.

Similarly for the network namespace we have the same set of files
showing up in different places in /proc with no large coherency
issues despite the same files being in multiple places in the
dcache.

The only piece of the puzzle new in sysfs is directory rename
support.  Which takes a little work but seems sane.

When I mentioned I was doing this Al said:
> Excuse me, _what_?  Are you seriously suggesting going through all dentry
> trees, doing d_move() in each?  I want to see your locking.  It's promising
> to be worse than devfs had ever been.  Much worse.

Odd I thought I sent Al a reply to that bold statement but it doesn't
appear in the archive.

At any rate I'm not afraid of more code review and testing.

At the time Al made those statements his concerns about coherency
and locking nightmares did not seem to apply to these patches and 
they don't seem to apply now.

I will happily admit the VFS does not like to work with filesystems
where the state changes behind it's back.  That is the position we are
in fundamentally with sysfs and proc, and the locking works today.
Multiple superblocks for sysfs does not change that in any significant
way.

So bring on the tough code review and concrete objections.
The code can take it and it can only get better for it.

Eric

