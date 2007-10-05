Return-Path: <linux-kernel-owner+w=401wt.eu-S1761903AbXJEMOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903AbXJEMOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbXJEMOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:14:03 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40388 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXJEMOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:14:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <htejun@gmail.com>, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver model
References: <11902755392688-git-send-email-htejun@gmail.com>
	<20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com>
	<m1zlz7hpvn.fsf_-_@ebiederm.dsl.xmission.com>
	<20071005062302.GB16914@kroah.com>
Date: Fri, 05 Oct 2007 06:12:41 -0600
In-Reply-To: <20071005062302.GB16914@kroah.com> (Greg KH's message of "Thu, 4
	Oct 2007 23:23:02 -0700")
Message-ID: <m1d4vtn4jq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
>
>>   Also fun is that the dev file implementation needs to be able to
>>   report different major:minor numbers based on which mount of
>>   sysfs we are dealing with.
>
> Um, no, that's not going to happen.  /dev/sda will _always_ have the
> same major:minor number, as defined by the LSB spec.  You can not break
> that at all.  So while you might not want to show all mounts
> /sys/devices/block/sda/ the ones that you do, will all have the LSB
> defined major:minor number assigned to it.

Hmm.  If that is in the LSB it must come from
Documentation/devices.txt  I'm not after changing the user
visible major/minor assignments.

Let me see if a concrete example will help.  Suppose I have
have a SAN with two disks:  disk-1 and disk-2.  I have
two machines A and B.  On machine A I get the mapping:
sda -> disk-1, sdb ->disk-2.  On machine B I wind up with
a different probe order so I get the mapping: sda -> disk-2
sdb ->disk-1.

To be very clear by sda I mean the block device with major 8 and
minor 0, and by sdb I mean the block device with major 8 and minor
16.

So I decide I want an environment on machine B that looks just
like the environment on machine A, so I can bring transfer over
a running program or whatever.  So I run around looking at UUID
labels and what not and I discover that the machine B knows disk-1 as
sdb and that machine A knows disk-1 as sda.  So I want to say:
/sys/devices/block/sdb show up in this other device namespace as
/sys/devices/block/sda.

In that instance a running program won't notice the difference.

Eric
