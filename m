Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYGDAv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYGDAv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 20:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYGDAvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 20:51:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60356 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYGDAvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 20:51:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, <netdev@vger.kernel.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.002784342@theryb.frec.bull.fr>
	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>
	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>
	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>
	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>
	<486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org>
	<486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>
	<486C4515.1070007@gmail.com> <m1hcb7o8lv.fsf@frodo.ebiederm.org>
	<486CB051.5000507@fr.ibm.com> <m14p77m9uy.fsf@frodo.ebiederm.org>
	<486CF71F.5090405@gmail.com>
Date: Thu, 03 Jul 2008 17:48:40 -0700
In-Reply-To: <486CF71F.5090405@gmail.com> (Tejun Heo's message of "Fri, 04 Jul
	2008 00:58:23 +0900")
Message-ID: <m1y74iiidz.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0088]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 00/15] sysfs support for namespaces
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When multiple namespaces are in use we can get multiple kernel objects
with the same name which is currently impossible to represent in sysfs.
In particular directories like /sys/class/net and /sys/kernel/uids have
significant problems.

Not wanting to change the user space interface and wanting to have a simple
implementation where all objects are in the kobject and sysfs trees.  The
decision has been made to tag objects with the namespace they live in,
and in a particular mount of sysfs only display objects with the tag
that corresponds to the namespaces in effect when sysfs was mounted.

After the last round of reviews the mount/umount logic is
significantly cleaned up and easier to maintain.  From a 10,000
foot view the code and the way it functions has remained the
same since we settled on tagged directories a year or so ago.   I
intend any future cleanups to be as incremental patches on top
of this existing set.

Lack of these patches are keeping the generally complete network
namespace work in 2.6.26 from being used and tested more heavily.
Can we please get the patches merged?

These patches are based off of 2.6.26-rc8 + the -gregkh tree from
last night.  Hopefully that means they apply -mm -gregkh and
-linux-next.

Eric


