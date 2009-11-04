Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbZKDFub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbZKDFub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 00:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZKDFu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 00:50:29 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37886 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZKDFu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 00:50:28 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 09/13] sysfs: Implement sysfs_getattr & sysfs_permission
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-9-git-send-email-ebiederm@xmission.com>
	<20091104042038.GE27639@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Nov 2009 21:50:16 -0800
In-Reply-To: <20091104042038.GE27639@us.ibm.com> (Serge E. Hallyn's message of "Tue\, 3 Nov 2009 22\:20\:38 -0600")
Message-ID: <m1pr7ybzzb.fsf@fess.ebiederm.org>
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

> So the inode->i_mutex is not needed?

Good question.  Nothing in sysfs needs it.  The VFS does not grab the
inode mutex on this path, but the vfs does grab the inode mutex when
writing to the inode.

Since the VFs isn't grabbing the inode_mutex there is probably a race in
here somewhere if someone looks at things just right.

I am too tired tonight to be that person.

Eric
