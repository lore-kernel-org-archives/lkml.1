Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861Ab0AVJPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0AVJPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708Ab0AVJPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:15:12 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57676 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab0AVJPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:15:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DZkqbRavQHxdaiiXFUny3VPEijiadgaWrAGawGMAXknRtVzWzIUGlq8OTLJkrjm2N/
         2JuRp1G9RPjvtkmaM8RmKy9BcNMayXf4dtoCX/nLKrPlIfXhx5x2+p4YJ2SMJo73NwRw
         zEHV0m7CHxJcYoDggS90BzLUGZaSw6ij5eNIU=
MIME-Version: 1.0
In-Reply-To: <20100121090510.GA908@infradead.org>
References: <6fb445941001200112o2934f805l4eb4f78000e9527e@mail.gmail.com>
	 <6fb445941001200120m3aa5e944j54a6f645ce82d76f@mail.gmail.com>
	 <4B57C3C3.9010606@schaufler-ca.com>
	 <20100121090510.GA908@infradead.org>
Date: Fri, 22 Jan 2010 17:15:05 +0800
Message-ID: <6fb445941001220115y6b99f7b4g306ea23d3202969@mail.gmail.com>
Subject: Re: About ACL for IPC Object
From: zhou peng <ailvpeng25@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, sds@tycho.nsa.gov, jra@samba.org,
       linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you all for so many solutions.

I want to control some IPC object (shm, msg queue, semphore) can be
accessed by which named user or named group just like file objects ACL
do.

I studied the solution you all referred, The SELinux is powerful but
may be somewhat complicated. And I am confused with Christoph
Hellwig‘s solution using tmpfs.

2010/1/21 Christoph Hellwig <hch@infradead.org>:
> On Wed, Jan 20, 2010 at 07:02:27PM -0800, Casey Schaufler wrote:
>> zhou peng wrote:
>> > Hi all,
>> >
>> > There are ACL in file system, but why there are no ACL implementation
>> > in IPC object, eg. shm, message queue, FIFO?
>> >
>>
>> Most people haven't noticed that IPC objects are even there, much less
>> that they have mode bits and not ACLs. Even when we were doing security
>> evaluations on Unix boxes in the 1990's they were considered insufficiently
>> interesting to justify the additional work to do ACLs.
>>
>> If you really want ACLs on IPC objects it would make a dandy little
>> project for a summer. I would be happy to review patches.

Thanks. It's interesting to add ACL over IPC objects. I want to have a try.

>
> Or use the posix IPC mechanisms.  The Posix shared memory has ACL by
> using tmpfs as the backing store, and we could add similar support to
> Posix messages queues as they are also backed by a normal filesystem.

Christoph Hellwig, This way may be convinent. Could you give some
detailed message. :)
I only find /proc/ipc/shm file which contain the info of shm objs,and
tmpfs on /dev/shm which is empty.

>
> Adding this support to the old SYSV IPC mechanisms would be much harder
> as they do not fit into the file backed model we use everywhere else at
> all.

Just like file objects, the mode bits are implment over IPC objects
without file backed, so I think adding ACL support to IPC objects may
be somewhat reasonable :)

>
>



-- 
zhoupeng
