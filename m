Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbYGAPHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbYGAPHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYGAPHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:07:11 -0400
Received: from nebensachen.de ([195.34.83.29]:53345 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbYGAPHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:07:09 -0400
X-Hashcash: 1:20:080701:rjw@sisk.pl::bxGrE42RYUH/Xn3Q:0000005wuJ
X-Hashcash: 1:20:080701:david@fromorbit.com::3Z1bfQm8p/FRSQ47:0000000000000000000000000000000000000000000e/2
X-Hashcash: 1:20:080701:xfs-masters@oss.sgi.com::DU31EoNGX6GcwyLJ:000000000000000000000000000000000000004xA8
X-Hashcash: 1:20:080701:jeremy@goop.org::0jK4RFy6NVptoIa+:001gBy
X-Hashcash: 1:20:080701:hmh@hmh.eng.br::tbgLeCFA8NteFmRe:000AWw/
X-Hashcash: 1:20:080701:mrmacman_g4@mac.com::6JmQx4IqnniOrVQg:0000000000000000000000000000000000000000002Uls
X-Hashcash: 1:20:080701:mjg59@srcf.ucam.org::3I0BVNHkFcyVQZSe:0000000000000000000000000000000000000000005RnM
X-Hashcash: 1:20:080701:dgc@sgi.com::8sET5lYwTMlFnI6z:000000Hz4a
X-Hashcash: 1:20:080701:linux-kernel@vger.kernel.org::WzN+jJJpUzbD96zf:0000000000000000000000000000000000+G1
X-Hashcash: 1:20:080701:jens.axboe@oracle.com::3KvPmTZrR5XNyJlV:00000000000000000000000000000000000000004OCb
From: Elias Oltmanns <eo@nebensachen.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <200807010038.43362.rjw@sisk.pl>
	<20080701063835.GQ29319@disturbed> <200807011635.44696.rjw@sisk.pl>
Date: Tue, 01 Jul 2008 17:05:29 +0200
Message-ID: <87tzf9hcg6.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Tuesday, 1 of July 2008, Dave Chinner wrote:
>> On Tue, Jul 01, 2008 at 12:38:41AM +0200, Rafael J. Wysocki wrote:
>
>> > On Tuesday, 1 of July 2008, Dave Chinner wrote:
>> > > On Mon, Jun 30, 2008 at 11:00:43PM +0200, Rafael J. Wysocki wrote:
>> > > > On Monday, 30 of June 2008, Dave Chinner wrote:
[...]
>> > > > > What do you do with a sync I/O (read or write)? The 
>> > > > > process is going to have to go to sleep somewhere in D state waiting
>> > > > > for that I/O to complete.  If you're going to intercept such
>> > > > > processes somewhere else to do something magic, then why not put
>> > > > > that magic in vfs_check_frozen()?
>> > > > 
>> > > > This might work too, but it would be nice to do something independent of the
>> > > > freezer, so that we can drop the freezer when we want and not when we are
>> > > > forced to.
>> > > 
>> > > vfs_check_frozen() is completely independent of the process freezer.
>> > 
>> > Well, can you please tell me how exactly that works, then?
>> 
>> Try looking at the code. When we freeze a filesystem sb->s_frozen
>> changes state depending on the level of freeze currently obtained
>> by the filesystem. And:
>> 
>> #define vfs_check_frozen(sb, level) \
>>         wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
>> 
>> Pretty bloody simple, really.
>
> OK
>
> Do all of the filesystems implement the freezing?

There is some work in progress [1]. If you think this will help you to
address this issue on the fs level, where I think it should be done, you
may even be able to request some changes to fit your needs before it
gets merged into mainline.

Regards,

Elias

[1] http://permalink.gmane.org/gmane.linux.file-systems/24716
