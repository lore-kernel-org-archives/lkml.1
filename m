Return-Path: <linux-kernel-owner+w=401wt.eu-S966209AbXFGD1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966209AbXFGD1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 23:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965395AbXFGD1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 23:27:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:49203 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965270AbXFGD1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 23:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jpnMcUtnPFTr0C21/81z+G+FIsFQn2IPSfs4eKlq+Y7c1fsZ9Cgdd5ESJBn0Ec0w/vVt9CAVzgSrPBeFo98H3KSlSRYjuxFrWdeocbs927kh709fZjCThGrdM06Yu9jTMugJkMVHjbPiZtyee8kzqXUPMMQBRzizndG/Chz9vhI=
Message-ID: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
Date: Wed, 6 Jun 2007 23:27:01 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, ebiederm@xmission.com, pbadari@us.ibm.com,
       torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman writes:
> Badari Pulavarty <pbadari@us.ibm.com> writes:

>> Your recent cleanup to shm code, namely
>>
>> [PATCH] shm: make sysv ipc shared memory use stacked files
>>
>> took away one of the debugging feature for shm segments.
>> Originally, shmid were forced to be the inode numbers and
>> they show up in /proc/pid/maps for the process which mapped
>> this shared memory segments (vma listing). That way, its easy
>> to find out who all mapped this shared memory segment. Your
>> patchset, took away the inode# setting. So, we can't easily
>> match the shmem segments to /proc/pid/maps easily. (It was
>> really useful in tracking down a customer problem recently).
>> Is this done deliberately ? Anything wrong in setting this back ?
>
> Theoretically it makes the stacked file concept more brittle,
> because it means the lower layers can't care about their inode
> number.
>
> We do need something to tie these things together.
>
> So I suspect what makes most sense is to simply rename the
> dentry SYSVID<segmentid>

Please stop breaking things in /proc. The pmap command relys
on the old behavior. It's time to revert. Put back the segment ID
where it belongs, and leave the key where it belongs too.

Containers are NOT worth breaking our ABIs left and right.
We don't need to leap off that bridge just because Solaris did,
unless you can explain why complexity and bloat are desirable.
We already have SE Linux, chroot, KVM, and several more!
