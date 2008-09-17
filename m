Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYIQTFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYIQTFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYIQTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:05:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54410 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYIQTFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:05:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
References: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com>
Date: Wed, 17 Sep 2008 11:55:14 -0700
In-Reply-To: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com>
	(Cornelia Huck's message of "Wed, 17 Sep 2008 13:08:05 +0200")
Message-ID: <m1r67i61rh.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, greg@kroah.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cornelia Huck <cornelia.huck@de.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1912]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH]sysfs: Don't emit a warning when sysfs_rename_link() fails.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:

> Hi Greg, hi Eric,
>
> the recent sysfs tagged directory changes switched device_rename() to
> sysfs_rename_link() - which is a good thing but AFAICS re-introduces
> the scary warnings when a netdevice is renamed to something that
> already exists (which I tried to fix with
> 36ce6dad6e3cb3f050ed41e0beac0070d2062b25).

A netdevice can not be renamed to something that already exists, correctly
and still emit warnings.  Either it is a noop rename in which case
the fact that we delete the link before creating it will avoid warnings.
Or we are actually using a conflicting name.  In which case it is a
real and valid problem.  The netdev layer especially since the
networking layer already has validated that the rename is valid
before calling device_rename.

> The following patch switches sysfs_rename_link() to non-warning symlink
> creation again. It is on top of the current driver core series.

We don't need this.  Using the non-warning symlink creation is unnecessary.
Using non-warning symlink creation hides real errors.

In practice any errors that show up will be errors in sysfs, because
the network subsystem validates everything before calling us.

Eric
