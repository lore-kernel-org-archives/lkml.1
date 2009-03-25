Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZCYFyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZCYFyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZCYFy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:54:28 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:32964 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZCYFy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:54:27 -0400
To: Alex Chiang <achiang@hp.com>
Cc: htejun@gmail.com, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
References: <20090325035707.15921.42150.stgit@bob.kio>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 24 Mar 2009 22:54:17 -0700
In-Reply-To: <20090325035707.15921.42150.stgit@bob.kio> (Alex Chiang's message of "Tue\, 24 Mar 2009 22\:16\:46 -0600")
Message-ID: <m13ad2xi46.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: achiang@hp.com, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kay.sievers@vrfy.org, stern@rowland.harvard.edu, cornelia.huck@de.ibm.com, greg@kroah.com, htejun@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alex Chiang <achiang@hp.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Interesting.

Fixing a read/writer deadlock by allowing the writers to nest
inside the readers.

My first impression is that it is too clever.

Furthermore I think this is walking around the edges of a more
general problem.   How should we serial hotplug and hotunplug
in general.  In what context should remove methods run in.

My impression is that we have a huge hole in our infrastructure
for hotplug drivers.  Problems like how do we get a user space
context for the code to run in and how do we handle
multiple hotplug actions for overlapping device trees from
stomping on each other.

My hypothesis is once we solve this for the general case of
device hotplug and removal we won't need special support from
sysfs.  At least not in the suicidal way.

We still have very weird cases such as the lock inversion that
we have today between rtnl_lock and active reference count,
coming from the networking code.

Eric
