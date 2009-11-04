Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZKDEL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZKDEL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZKDEL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:11:57 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38588 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZKDEL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:11:56 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 07/13] sysfs: Update s_iattr on link and unlink.
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-7-git-send-email-ebiederm@xmission.com>
	<20091104035413.GD27639@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Nov 2009 20:11:56 -0800
In-Reply-To: <20091104035413.GD27639@us.ibm.com> (Serge E. Hallyn's message of "Tue\, 3 Nov 2009 21\:54\:13 -0600")
Message-ID: <m1pr7zc4j7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Currently sysfs updates the timestamps on the vfs directory
>> inode when we create or remove a directory entry but doesn't
>> update the cached copy on the sysfs_dirent, fix that oversight.
>
> confused... why not do this in sysfs_addrm_finish()?
>
> I guess you'd have to do at it at top before dropping sysfs_mutex
> so it wouldn't be as pretty as I was thinking, but at least you
> could just do it once.

Well sysfs_addrm_finish doesn't really know if you did anything.

Beyond that my ultimate goal is to kill sysfs_addrm_start and
sysfs_addrm_finish.  Of course that requires fixing all of the
sysfs users that depend on the impossible to get right recursive
directory removal in sysfs, so it is not the subject of this patchset.

Eric
