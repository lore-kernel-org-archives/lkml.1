Return-Path: <linux-kernel-owner+w=401wt.eu-S1765236AbZDBS30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765236AbZDBS30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759806AbZDBS3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:29:12 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:55990 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbZDBS3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j53d4qpO04M3r/sCKomicw3IPQMG094YHpNo+Zs5oBmNtPCZUrCUog6toUs8jyNa0I
         VzoKXC5ksA4yOq7MpbkXhPOgyb9j7PoPSYJ9iqO3oPDT6rBHeP7p5lNe/uCZ85+Tshrd
         qsUhhNSaKO0m2G+03ZMI3FHQTasdHUrciANOU=
MIME-Version: 1.0
In-Reply-To: <49D4F044.1040306@ph.tum.de>
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com>
	 <20090402055356.GC10642@mit.edu>
	 <a4423d670904020042x6b76715du48a15e988a05019d@mail.gmail.com>
	 <a4423d670904020439m621990bch9482d19f0e48e7d2@mail.gmail.com>
	 <a4423d670904020547s72972089t3c135a92af6751d4@mail.gmail.com>
	 <49D4BDF2.2070102@ph.tum.de> <20090402145436.GF10642@mit.edu>
	 <49D4D74F.1020904@ph.tum.de> <20090402154123.GG10642@mit.edu>
	 <49D4F044.1040306@ph.tum.de>
Date: Thu, 2 Apr 2009 22:29:05 +0400
Message-ID: <a4423d670904021129s61ee55bfh584dbe7bc4322929@mail.gmail.com>
Subject: Re: 2.6.29-git: cannot mount ext4/loop
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/2 Thiemo Nagel <thiemo.nagel@ph.tum.de>:
> Theodore Tso wrote:
>>
>> On Thu, Apr 02, 2009 at 05:18:39PM +0200, Thiemo Nagel wrote:
>>>
>>> Theodore Tso wrote:
>>>>
>>>> On Thu, Apr 02, 2009 at 03:30:26PM +0200, Thiemo Nagel wrote:
>>>>>
>>>>> When I added the block range checks, initially I was assuming that
>>>>> when EXTENTS_FL is not set, the inode->i_data *always* contains
>>>>> references to further blocks.  Ted showed me wrong and added the
>>>>> condition
>>>>>
>>>>>        ISREG() || ISDIR() || ( ISLNK() && !is_fast_symlink() )
>>>>>
>>>>> before that assumption can be made.  But maybe we need some further
>>>>> restraints?
>>>>
>>>> It's a endian-problem; we're missing le32_to_cpu() in that patch.
>>>> Sparc is big-endian.
>>>
>>> Sorry for that.
>>
>> Could you also fix the types?  bref should have a type of __le32, not
>> unsigned int, and when you pass in the reference to
>> __ext4_check_blockref(), there was an inappropriate cast to unsigned
>> int which hid kernel's natural type checking to catch these sorts of
>> problems.
>
> So I was really asking for things to go wrong...  :-(
> I hope the attached patch handles conversion and types in the right way.
>  It's compile-tested only, the current ext4 tree crashes my machine.

It works fine, thanks.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
