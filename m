Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZKGL53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZKGL53 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 06:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZKGL52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 06:57:28 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55966 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZKGL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 06:57:27 -0500
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: tj@kernel.org, serue@us.ibm.com, gregkh@suse.de, kay.sievers@vrfy.org,
       greg@kroah.com, linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com,
       linux-fsdevel@vger.kernel.org, eric.dumazet@gmail.com, bcrl@lhnet.ca,
       ebiederm@aristanetworks.com
Subject: Re: [PATCH 12/13] sysfs: Propagate renames to the vfs on demand
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-12-git-send-email-ebiederm@xmission.com>
	<20091104214938.GA21033@us.ibm.com> <m13a4ux86v.fsf@fess.ebiederm.org>
	<4AF4D76C.6090008@kernel.org> <m1y6mjw03m.fsf@fess.ebiederm.org>
	<E1N6jDk-0006eq-23@pomaz-ex.szeredi.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 07 Nov 2009 03:57:08 -0800
In-Reply-To: <E1N6jDk-0006eq-23@pomaz-ex.szeredi.hu> (Miklos Szeredi's message of "Sat\, 07 Nov 2009 12\:12\:40 +0100")
Message-ID: <m1aayypmy3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Fri, 06 Nov 2009, ebiederm@xmission.com (Eric W. Biederman wrote:
>> Tejun Heo <tj@kernel.org> writes:
>> 
>> > Hello,
>> >
>> > Eric W. Biederman wrote:
>> >> It isn't what I want but it is what the VFS requires.  If let the vfs
>> >> continue on it's delusional state we will leak the vfs mount and
>> >> everything mounted on top of it, with no way to remove the mounts.
>
> "umount -l" on the whole thing will clear any submounts up too.
>
>> >
>> > This is caused by not having any way to prevent deletion on
>> > directories with submounts, right?  How does other distributed
>> > filesystems deal with directories with submounts going away underneath
>> > it?
>> 
>> NFS does exactly the same thing I am doing.
>
> Yes, this is a problem for NFS too.  You cannot tell the NFS server
> "this directory is mounted on some client, don't let anything happen
> to it!".  Basically the remaining choices are:
>
>  a) let the old path leading up to the mount still be accessible, even
>  though it doesn't exist anymore on the server (or has been replaced
>  with something different)
>
>  b) automatically dissolve any submounts if the path disappeard on the
>  server
>
> I think Al was arguing in favor of b), while Linus said that mounts
> must never just disappear, so a) is better.  I don't think an
> agreement was reached.

I haven't seen that conversation.  I do know it is non-intutive and if
you attempt to delete what is a mount point in another mount namespace
and it won't go away.  (What we do for non-distributed filesystems).
So I would favor mount points dissolving if we had the infrastructure.

Regardless the goal for now is to simply catch up with other distributed
filesystems.

Eric
