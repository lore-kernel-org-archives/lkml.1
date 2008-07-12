Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYGLDwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYGLDwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 23:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYGLDwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 23:52:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40420 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYGLDwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 23:52:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
References: <Pine.LNX.4.44L0.0807112255450.9023-100000@netrider.rowland.org>
Date: Fri, 11 Jul 2008 20:50:12 -0700
In-Reply-To: <Pine.LNX.4.44L0.0807112255450.9023-100000@netrider.rowland.org>
	(Alan Stern's message of "Fri, 11 Jul 2008 23:04:57 -0400 (EDT)")
Message-ID: <m1ej5z4v7v.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Stern <stern@rowland.harvard.edu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3664]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [linux-pm] [PATCH -mm 1/2] kexec jump -v12: kexec jump
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Fri, 11 Jul 2008, Eric W. Biederman wrote:
>
>> I just realized with a little care the block layer does have support for this,
>> or something very close.
>> 
>> You setup a software raid mirror with one disk device.    The physical
>> device can come in and out while the filesystems depend on the real device.
>
> Do you mean "the filesystems depend on the logical RAID device"?  

Oh yes. Thinko.

> What's to prevent userspace from accessing the physical device 
> directly?

Nothing.

> What this amounts to, in the end, is having a way to distinguish the
> set of I/O requests coming from the hibernation code (reading or
> writing the memory image) from the set of all other I/O requests.  The
> driver or the block layer has to be set up to allow the first set
> through while blocking the second set.  (And don't forget about the 
> complications caused by error-recovery I/O during the hibernation 
> activity!)

I guess this problem exists but it is not at all the problem I was
thinking of.

> Forcing the second set of requests to filter through an extra software 
> layer is a clumsy way of accomplishing this.  There ought to be a 
> better approach.

The point was something different.  The reasons we can not store the
state of the system with the hardware devices logically hot unplugged
(and thus reuse all of the find device hotplug methods) is because
things like the filesystem layer don't know how to cope with their
block devices going away an coming back.

That is the problem inserting an virtual software device in the middle
can solve.  If that works should there be a better way?  Certainly but
to prove it out starting with a block device wrapper is a trivial way to
go.

Eric
