Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbZCaHnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbZCaHnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZCaHn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:43:28 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:22981 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039AbZCaHn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:43:27 -0400
Message-ID: <49D1C929.4070403@panasas.com>
Date: Tue, 31 Mar 2009 10:41:29 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: avishay@gmail.com, jeff@garzik.org, linux-fsdevel@vger.kernel.org,
       osd-dev@open-osd.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       linux-next@vger.kernel.org
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
References: <49C1331D.1080805@panasas.com> <20090330142200.af4b497c.akpm@linux-foundation.org> <49D1C44D.8060806@panasas.com>
In-Reply-To: <49D1C44D.8060806@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 07:43:24.0593 (UTC) FILETIME=[5F3F3210:01C9B1D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 10:20 AM, Boaz Harrosh wrote:
> On 03/31/2009 12:22 AM, Andrew Morton wrote:
>> On Wed, 18 Mar 2009 19:45:01 +0200
>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>>> What's new since last iteration:
>>>
>>> * I completely re-wrote the [PATCH 4/8] exofs: address_space_operations
>>>   in which we actually write/read to/from osd-storage. The difference is
>>>   that now we try to accumulate as many contiguous pages as possible and
>>>   send them as one large request. As opposed to writing each page at a
>>>   time, in the previous patchset.
>>>
>>> * [PATCH 5/8] exofs: dir_inode and directory operations received lots
>>>   of love thanks to Evgeniy Polyakov's grate comments.
>>>
>>> exofs is a file system that uses an OSD device as it's back store.
>>>
>>> OSD is a new T10 command set that views storage devices not as a large/flat
>>> array of sectors but as a container of objects, each having a length, quota,
>>> time attributes and more. Each object is addressed by a 64bit ID, and is
>>> contained in a 64bit ID partition. Each object has associated attributes
>>> attached to it, which are integral part of the object and provide metadata about
>>> the object. The standard defines some common obligatory attributes, but user
>>> attributes can be added as needed.
>>>
>>> Here is the list of patches
>>> [PATCH 1/8] exofs: Kbuild, Headers and osd utils
>>> [PATCH 2/8] exofs: file and file_inode operations
>>> [PATCH 3/8] exofs: symlink_inode and fast_symlink_inode operations
>>> [PATCH 4/8] exofs: address_space_operations
>>> [PATCH 5/8] exofs: dir_inode and directory operations
>>> [PATCH 6/8] exofs: super_operations and file_system_type
>>> [PATCH 7/8] exofs: Documentation
>>> [PATCH 8/8] fs: Add exofs to Kernel build
>> Are all the prerequisites for exofs now in mainline?
>>
> 
> Yes they are all in
> 
>>> This patchset is also available on:
>>>   git-clone git://git.open-osd.org/linux-open-osd.git linux-next
>>> or on the web at:
>>>   http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/linux-next
>> Well I could merge them, but given that you have a git tree, a more
>> convenient path would be for us to include your tree in linux-next 
> 
> As Stephan said they are there since 2.6.29-rc1
> 
>> and
>> then you ask Linus to pull it directly when the time comes.
>>
> 
> I was hoping the time is now
> 
>> I'm unsure when that time will come.  Who has reviewed this work and
>> what was the result?
>>
>>
> 
> The patches have been reveiwed on linux-kernel and linux-fsdevel for
> 5-6 rounds. Each round drew it's comments which I fixed and so on.
> 

I forgot to say. Some of the people that sent comments where:
  Marcin Slusarz <marcin.slusarz@gmail.com>
  Evgeniy Polyakov <zbr@ioremap.net>
  Jeff Garzik <jeff@garzik.org>
  Pavel Machek <pavel@suse.cz>
  Benny Halevy <bhalevy@panasas.com>
  Alan Cox <alan@lxorguk.ukuu.org.uk>
  Andrew Morton <akpm@linux-foundation.org>

And then there was a long flame war about user-mode API, which I now
have, and all in kernel utilities are gone.

To the best of my knowledge I have addressed all comments, at least
no one complained.

<snip>

Thanks
Boaz
