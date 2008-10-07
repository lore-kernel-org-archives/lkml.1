Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYJGIgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYJGIgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 04:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYJGIf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 04:35:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38730 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYJGIf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 04:35:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<20081005053236.GA9472@kroah.com>
Date: Tue, 07 Oct 2008 01:27:17 -0700
In-Reply-To: <20081005053236.GA9472@kroah.com> (Greg KH's message of "Sat, 4
	Oct 2008 22:32:36 -0700")
Message-ID: <m1bpxwajyy.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0604]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> Al, thanks a lot for the review, I really appreciate it.

> Eric, I've removed the following patches from my tree so you can rework
> them, if you want to.

Well what Al focused on has very little to do with tagged directories
and mostly do with sysfs itself.  So my current plan is to write
incremental patches that fix sysfs_chmod_file and sysfs_mv_dir,
in the next couple of hours and call it good for the moment.

Unless someone will give an example of how having multiple superblocks
sharing inodes is a problem in practice for sysfs and call it good
for 2.6.28.  Certainly it shouldn't be an issue if the network namespace
code is compiled out.  And it should greatly improve testing of the
network namespace to at least have access to sysfs.

Later Tejun or I or possibly someone else who cares can go back
and simplify the sysfs locking to remove the need for multiple
superblocks sharing inodes, and to address the other big nasties in
the current sysfs implementation.  

Greg I agree with Al that sysfs isn't perfect but we sure aren't going
to fix it if you keep dropping or taking years to merge every patch
from the people working on it, and then dropping those patches because
someone frowns at them.

Eric
