Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbXD0ENs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbXD0ENs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 00:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbXD0ENr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 00:13:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52888 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbXD0ENq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 00:13:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jengelh@linux01.gwdg.de, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, hpa@zytor.com
Subject: Re: [patch] unprivileged mounts update
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu>
	<E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu>
	<m1r6q8s735.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.61.0704262107130.506@yvahk01.tjqt.qr>
	<E1HhAYu-000361-00@dorka.pomaz.szeredi.hu>
Date: Thu, 26 Apr 2007 22:10:31 -0600
In-Reply-To: <E1HhAYu-000361-00@dorka.pomaz.szeredi.hu> (Miklos Szeredi's
	message of "Thu, 26 Apr 2007 22:27:32 +0200")
Message-ID: <m1abwujw3s.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

>> On Apr 25 2007 11:21, Eric W. Biederman wrote:
>> >>
>> >> Why did we want to use fsuid, exactly?
>> >
>> >- Because ruid is completely the wrong thing we want mounts owned
>> >  by whomever's permissions we are using to perform the mount.
>> 
>> Think nfs. I access some nfs file as an unprivileged user. knfsd, by
>> nature, would run as euid=0, uid=0, but it needs fsuid=jengelh for
>> most permission logic to work as expected.
>
> I don't think knfsd will ever want to call mount(2).
>
> But yeah, I've been convinced, that using fsuid is the right thing to
> do.

Actually knfsd does call mount when it crosses a mount point on the nfs
server it generates an equivalent mount point in linux.  At least I think
that is the what it is doing.  It is very similar to our mount propagation
path.

However as a special case I don't think the permission checking is likely
to bite us there.  It is worth double checking once we have the other details
ironed out.

Eric
