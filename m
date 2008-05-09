Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbYEISUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbYEISUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYEISUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:20:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38366 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYEISUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:20:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: ebiederm@xmission.com (Eric W. Biederman), Greg KH <gregkh@suse.de>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <20080506173030.653828076@theryb.frec.bull.fr>
	<20080506173335.922289888@theryb.frec.bull.fr>
	<m13aoueyq8.fsf@frodo.ebiederm.org> <20080507190838.GA4467@suse.de>
	<m1hcd9esxo.fsf@frodo.ebiederm.org>
	<20080508102844.25642ef7@gondolin.boeblingen.de.ibm.com>
	<m1myn0d298.fsf@frodo.ebiederm.org>
	<20080509073556.3c342d14@gondolin.boeblingen.de.ibm.com>
Date: Fri, 09 May 2008 11:16:10 -0700
In-Reply-To: <20080509073556.3c342d14@gondolin.boeblingen.de.ibm.com>
	(Cornelia Huck's message of "Fri, 9 May 2008 07:35:56 +0200")
Message-ID: <m1ve1nbaxh.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 10/11] avoid kobject name conflict with different namespaces
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:

> On Thu, 08 May 2008 12:28:19 -0700,
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> Do you remember if we have ever sorted out the race between _move
>> and module unload/directory teardown at the sysfs level?
>
> Unfortunately I can't remember anything about this, do you have a
> pointer to the original discussion?

Ok the conversation was:
"[Bluez-devel] Oops involving RFCOMM and sysfs"
http://lkml.org/lkml/2007/12/28/87

Following the thread through it appears the bug was fixed
and it wasn't the race Al Viro was concerned about.
http://lkml.org/lkml/2008/1/9/59

And it looks like all of the symptoms have been corrected.
Yeah!

Which implies to me that kobject_move has the same locking
restrictions that kobject_rename has.  I.e. the upper level
better do what it takes to make the operation safe.

Which says that at least for now not worrying about the locking
between sysfs_move_dir/sysfs_rename_dir and sysfs_remove_dir is ok.
As we require the upper levels not to do that.

Which says that we may be able to figure out how to merge
sysfs_move_dir and sysfs_rename_dir.  It is still a nasty business
though.

Eric

