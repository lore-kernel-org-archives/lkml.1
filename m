Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYH1Xoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYH1Xoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYH1Xo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 19:44:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53435 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYH1XoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 19:44:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Peter Chubb <peterc@gelato.unsw.edu.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Theodore Tso <tytso@mit.edu>,
       Arnd Bergmann <arnd@arndb.de>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
References: <20080807224033.FFB3A2C1@kernel>
	<200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com>
	<200808111853.13854.arnd@arndb.de> <1218484114.5598.43.camel@nimitz>
	<48A0CD86.6030704@goop.org> <87d4kfds5i.wl%peterc@chubb.wattle.id.au>
	<20080812144905.GA16016@us.ibm.com>
Date: Thu, 28 Aug 2008 16:40:21 -0700
In-Reply-To: <20080812144905.GA16016@us.ibm.com> (Serge E. Hallyn's message of
	"Tue, 12 Aug 2008 09:49:05 -0500")
Message-ID: <m1abewaeu2.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4827]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMDateMe_00 Spam To Date Someone
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: checkpoint/restart ABI
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Peter Chubb (peterc@gelato.unsw.edu.au):

>> Beefing up ptrace or fixing /proc to be a real debugging interface
>> would be a start ... when you can get at *all* the info you need,
>
> Except we don't really want to export all the info you need for a
> complete restartable checkpoint.  And especially not make it
> generally writable.

That and unless we get a lot of synergy from authors of debuggers
and debugging code it is a more general and slower interface for
no apparent gain.

> We have also started down that path using ptrace (see cryo, at
> git://git.sr71.net/~hallyn/cryodev.git).
>
> Right before the containers mini-summit, where the general agreement was
> that a complete in-kernel solution ought to be pursued, I had tried
> a restart using a binary format that read a checkpoint file and used
> cryo (userspace using ptrace) for the rest of the restart, only
> because there was no other reasonable way to set tsk->did_exec on
> restart.

Can we please describe this as the giant syscall approach.  Instead
of a complete in-kernel solution.  There are things like filesystems
that should be checkpointed separately, or not checkpointed at all.

However there is a large set of processes and process state that always
goes together and if you checkpoint a container you always want.

So building something that is roughly equivalent to a binfmt module
but that can save and restore multiple tasks with a single operation
looks like the right granularity.

>> Jeremy> Lightweight filesystem checkpointing, such as btrfs provides,
>> Jeremy> would seem like a powerful mechanism for handling a lot of the
>> Jeremy> filesystem state problems.  It would have been useful when we
>> Jeremy> did this...
>> 
>> And how!  saving bits of files was very timeconsuming.
>
> Yes, we're looking forward to using btrfs' snapshots :)

Yep.  And in the case of migration we don't even need to snapshot
a filesystem just mount it from on the target machine.  Except for
the unlinked files challenge.

Eric
