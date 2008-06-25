Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYFYVVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYFYVVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYFYVV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:21:27 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47766 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYFYVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:21:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.746054454@theryb.frec.bull.fr>
	<485F0812.4090903@gmail.com> <20080625184409.GA8353@us.ibm.com>
Date: Wed, 25 Jun 2008 14:11:39 -0700
In-Reply-To: <20080625184409.GA8353@us.ibm.com> (Serge E. Hallyn's message of
	"Wed, 25 Jun 2008 13:44:09 -0500")
Message-ID: <m1wskd43uc.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 11/11] sysfs: user namespaces: fix bug with clone(CLONE_NEWUSER) with fairsched
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Except the sysfs mount holds no refcount on the userns.  So as long as we
> do the ida tagging as you suggested in your response to patch 6, there
> should be no reference to the user_ns left in sysfs code.
>
> The extra reference in patch #9 is for a light ref on the network
> namespace.  I'm still not sure that needs to be there, since if the
> network namespace goes away, it will properly unregister its sysfs
> mounts.  Eric, Benjamin, I really don't see any use for the hold_net()
> from sysfs.  What is it doing?

Mostly just being a sanity check.  We can remove that if it easier.

Eric
