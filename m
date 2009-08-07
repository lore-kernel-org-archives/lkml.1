Return-Path: <linux-kernel-owner+w=401wt.eu-S933698AbZHGUXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbZHGUXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbZHGUXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:23:48 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:37970 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbZHGUXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:23:47 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Eric Paris <eparis@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: [Patch v3] vfs: allow file truncations when both suid and write permissions set
References: <20090807100743.5822.90612.sendpatchset@localhost.localdomain>
	<1249675025.2694.15.camel@dhcp231-106.rdu.redhat.com>
Date: Sat, 08 Aug 2009 05:23:44 +0900
In-Reply-To: <1249675025.2694.15.camel@dhcp231-106.rdu.redhat.com> (Eric
	Paris's message of "Fri, 07 Aug 2009 15:57:05 -0400")
Message-ID: <87prb7v0dr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> On Fri, 2009-08-07 at 06:05 -0400, Amerigo Wang wrote:
>> V2 -> V3:
>> Call notify_change() before clearing suid/sgid.
>> Thanks to OGAWA Hirofumi.
>> 
>> V1 -> V2:
>> Introduce dentry_remove_suid(), and use it in do_truncate().
>> Thanks to Eric Paris.
>> 
>> 
>> When suid is set and the non-owner user has write permission,
>> any writing into this file should be allowed and suid should be
>> removed after that.
>> 
>> However, current kernel only allows writing without truncations,
>> when we do truncations on that file, we get EPERM. This is a bug.
>> 
>> Steps to reproduce this bug:
>> 
>> % ls -l rootdir/file1
>> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
>> % echo h > rootdir/file1
>> zsh: operation not permitted: rootdir/file1
>> % ls -l rootdir/file1
>> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
>> % echo h >> rootdir/file1
>> % ls -l rootdir/file1
>> -rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1
>> 
>> This patch fixes it.
>> 
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Eric Sandeen <esandeen@redhat.com>
>> Cc: Eric Paris <eparis@redhat.com>
>> Cc: Eugene Teo <eteo@redhat.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: hirofumi@mail.parknet.co.jp
>
> I was thinking about this and kept telling myself I was going to test v2
> before I ack/nak.  Clearly we shouldn't for the dropping of SUID if the
> process didn't have permission to change the ATTR_SIZE.
>
> Acked-by: Eric Paris <eparis@redhat.com>

BTW, Do you know why doesn't security modules fix the handling of
do_truncate() (i.e. ATTR_MODE | ATTR_SIZE). And why doesn't it allow to
pass ATTR_FORCE for it?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
