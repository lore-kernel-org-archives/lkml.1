Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbYD2TTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbYD2TTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYD2TTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:19:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57354 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbYD2TTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:19:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <20080429171015.473938697@theryb.frec.bull.fr>
	<20080429173621.GA16625@suse.de>
Date: Tue, 29 Apr 2008 12:14:21 -0700
In-Reply-To: <20080429173621.GA16625@suse.de> (Greg KH's message of "Tue, 29
	Apr 2008 10:36:21 -0700")
Message-ID: <m1d4o83242.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/10] sysfs tagged directories
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Tue, Apr 29, 2008 at 07:10:15PM +0200, Benjamin Thery wrote:
>> Here is the announcement Eric wrote back in December to introduce his 
>> patchset:
>
> <snip>
>
> Are the objections that Al Viro made to this patchset when it was last
> sent out addressed in this new series?

I'm trying to recall.  Al was nervous when the approach was described
to him but I don't remember him looking at specific patches and
objecting.

There was also an issue about races in sysfs between rename
and unlink that Al brought up, that causes real problems in
at least one piece of code that uses that functionality.  I have been
busy so I don't know if anyone has addressed that issue.  It is
independent but this patchset may make that issue slightly harder
to fix.

If the concern is Al nervousness with respect to locking order
(and that is complex) the only really sane way to fix that is
to dig into the VFS and change the lock ordering so that is 
friendlier to distributed filesystems like sysfs.

This patchset does not introduce any new lock ordering issues
but it may make the existing convolutions we have to go through
to keep the dcache for existing file handles in sync with the
internal sysfs tree more visible.  As of my last posting I am
not aware of any locking problems in the code itself.

Greg I had thought you had dropped the patchset simply because
you got busy.  I know it languished for a long time because of
that.

Eric
