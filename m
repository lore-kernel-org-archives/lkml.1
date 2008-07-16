Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYGPFus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYGPFus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYGPFuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:50:37 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:26449 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYGPFug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bFTPBtv3HYvRzP1Dh5n5j5EGd3dOwN3I4WtjLlqTSHFj+XG98Ln1+d3lK4xCaFrx0B
         /vrzeM9zDkuVkUpnUlVrI2qeF+UbK80WN+/f3L24BmLDeNH2el/m1ivJLPEaJFkuoi/M
         AJIt/iUE69tvB/kI7Tb4kQDeWVUqdIIsILZ+U=
Message-ID: <487D8C0A.9060100@gmail.com>
Date: Wed, 16 Jul 2008 14:50:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
 for device classes.
References: <m18wwiihbn.fsf_-_@frodo.ebiederm.org>	<m14p76ih9a.fsf_-_@frodo.ebiederm.org>	<m1zloyh2mb.fsf_-_@frodo.ebiederm.org>	<m1vdzmh2jr.fsf_-_@frodo.ebiederm.org>	<m1r6aah2hh.fsf_-_@frodo.ebiederm.org>	<m1mykyh2fu.fsf_-_@frodo.ebiederm.org>	<m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com>	<m1tzf593ny.fsf@frodo.ebiederm.org> <486E2C3B.6020603@gmail.com>	<20080704161200.GA1440@suse.de> <m1lk052ptp.fsf@frodo.ebiederm.org>	<487D6A24.9070001@gmail.com> <m17ibmbd39.fsf@frodo.ebiederm.org>
In-Reply-To: <m17ibmbd39.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
>> Eric, with the multiple superblocks, sysfs now uses inode from the
>> default sysfs_sb with dentries from other sb's.  Is this okay?  Are
>> there any other filesystems which do this?
> 
> I don't know of any other filesystems where this unique challenge arises.
> /proc almost qualifies but it never needs to be modified.
> 
> It is certainly ok to go from multiple dentries to a single inode.
> I'm trying to remember why I choose to do that.  I think both because it simplifies
> the locking and keeps us more efficient in the icache.

It's a bit scary tho.  Working inode->i_dentry or dentry->d_alias
crosses multiple sb's.  sysfs isn't too greedy about dcache/icache.
Only open files and directories hold them and only single copy of
sysfs_dirent is there for most nodes.  Wouldn't it be better to stay on
the safer side and use separate inode hierarchy?

Thanks.

-- 
tejun
