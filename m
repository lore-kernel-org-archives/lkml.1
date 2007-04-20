Return-Path: <linux-kernel-owner+w=401wt.eu-S1031007AbXDTQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031007AbXDTQfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030930AbXDTQfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:35:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57592 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031007AbXDTQfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:35:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 0/8]  mount ownership and unprivileged mount syscall (v4)
References: <20070420102532.385211890@szeredi.hu>
	<20070420124249.GC29498@sergelap.austin.ibm.com>
Date: Fri, 20 Apr 2007 10:33:13 -0600
In-Reply-To: <20070420124249.GC29498@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Fri, 20 Apr 2007 07:42:49 -0500")
Message-ID: <m18xcnknue.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Miklos Szeredi (miklos@szeredi.hu):
>> This patchset has now been bared to the "lowest common denominator"
>> that everybody can agree on.  Or at least there weren't any objections
>> to this proposal.
>> 
>> Andrew, please consider it for -mm.
>> 
>> Thanks,
>> Miklos
>> ----
>> 
>> v3 -> v4:
>> 
>>  - simplify interface as much as possible, now only a single option
>>    ("user=UID") is used to control everything
>>  - no longer allow/deny mounting based on file/directory permissions,
>>    that approach does not always make sense
>> 
>> ----
>> This patchset adds support for keeping mount ownership information in
>> the kernel, and allow unprivileged mount(2) and umount(2) in certain
>> cases.
>> 
>> The mount owner has the following privileges:
>> 
>>   - unmount the owned mount
>>   - create a submount under the owned mount
>> 
>> The sysadmin can set the owner explicitly on mount and remount.  When
>> an unprivileged user creates a mount, then the owner is automatically
>> set to the user.
>> 
>> The following use cases are envisioned:
>> 
>> 1) Private namespace, with selected mounts owned by user.
>>    E.g. /home/$USER is a good candidate for allowing unpriv mounts and
>>    unmounts within.
>> 
>> 2) Private namespace, with all mounts owned by user and having the
>>    "nosuid" flag.  User can mount and umount anywhere within the
>>    namespace, but suid programs will not work.
>> 
>> 3) Global namespace, with a designated directory, which is a mount
>>    owned by the user.  E.g. /mnt/users/$USER is set up so that it is
>>    bind mounted onto itself, and set to be owned by $USER.  The user
>>    can add/remove mounts only under this directory.
>> 
>> The following extra security measures are taken for unprivileged
>> mounts:
>> 
>>  - usermounts are limited by a sysctl tunable
>>  - force "nosuid,nodev" mount options on the created mount
>
> Very nice.  I like these semantics.
>
> I'll try to rework my laptop in the next few days to use this patchset
> as a test.

Agreed.  It appears the approach of adding owner ship information to
mount points and using that to control what may happen with them
in regards to mount/unmount is the only workable approach in the
unix environment.

Now to dig into the details and ensure that they are correct.

Eric
