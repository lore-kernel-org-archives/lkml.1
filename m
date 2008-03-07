Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbYCGJHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbYCGJHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYCGJHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:07:12 -0500
Received: from sacred.ru ([62.205.161.221]:38598 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbYCGJHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:07:08 -0500
Message-ID: <47D102D6.8070702@openvz.org>
Date: Fri, 07 Mar 2008 11:54:46 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Greg KH <greg@kroah.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 0/9] Devices accessibility control group (v4)
References: <47CED717.60406@openvz.org> <20080306015513.GA5359@kroah.com> <20080306031525.GA9070@sergelap.austin.ibm.com> <20080306043427.GA15498@kroah.com> <47CFAD06.7020501@openvz.org> <20080307084245.GA5004@ucw.cz>
In-Reply-To: <20080307084245.GA5004@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 07 Mar 2008 11:54:46 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2008-03-06 11:36:22, Pavel Emelyanov wrote:
>> Greg KH wrote:
>>> On Wed, Mar 05, 2008 at 09:15:25PM -0600, Serge E. Hallyn wrote:
>>>> Quoting Greg KH (greg@kroah.com):
>>>>> On Wed, Mar 05, 2008 at 08:23:35PM +0300, Pavel Emelyanov wrote:
>>>>>> Changes from v3:
>>>>>> * Ported on 2.6.25-rc3-mm1;
>>>>>> * Re-splitted into smaller pieces;
>>>>>> * Added more comments to tricky places.
>>>>>>
>>>>>> This controller allows to tune the devices accessibility by tasks,
>>>>>> i.e. grant full access for /dev/null, /dev/zero etc, grant read-only
>>>>>> access to IDE devices and completely hide SCSI disks.
>>>>>  From within the kernel itself?  The kernel should not be keeping track
>>>>> of the mode of devices, that's what the filesystem holding /dev is for.
>>>>> Those modes change all the time depending on the device plugged in, and
>>>>> the user using the "console".  Why should the kernel need to worry about
>>>>> any of this?
>>>> These are distinct from the permissions on device files.  No matter what
>>>> the permissions on the device files, a task in a devcg cgroup which
>>>> isn't allowed write to chardev 4:64 will not be able to write to
>>>> /dev/ttyS0.
>>> Then why not do that from userspace with a different /dev, or with a
>>> LSM?
>> Different dev is not suitable, since task may still call mknod to
>> create device it needs and use it. This is not about comfortable
>> use, this is about security.
> 
> And you may still take out mknod capability...

Sure we can. In that case we can pre-create only alowed devices for a container
and be happy, but this is not a flexible way of doing things. The main problem is
that udev will stop working in such a container. Patching one is not an option
either, for the reasons I have described before.

Many virtualization functionality we're submitting can be achieved via proper
userpace modifications, but we want to be able to run old software (from old
and even historic distributions) inside containers, so we have to make this
at the kernel level.

Thanks,
Pavel
