Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbZDBNyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbZDBNyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 09:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZDBNyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 09:54:01 -0400
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:59467 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbZDBNyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 09:54:01 -0400
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 09:54:01 EDT
Message-ID: <49D4BDF2.2070102@ph.tum.de>
Date: Thu, 02 Apr 2009 15:30:26 +0200
From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>, Theodore Tso <tytso@mit.edu>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-git: cannot mount ext4/loop
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com>	 <20090401225351.GA22621@orion> <20090402055356.GC10642@mit.edu>	 <a4423d670904020042x6b76715du48a15e988a05019d@mail.gmail.com>	 <a4423d670904020439m621990bch9482d19f0e48e7d2@mail.gmail.com> <a4423d670904020547s72972089t3c135a92af6751d4@mail.gmail.com>
In-Reply-To: <a4423d670904020547s72972089t3c135a92af6751d4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> 2009/4/2 Alexander Beregalov <a.beregalov@gmail.com>:
>> 2009/4/2 Alexander Beregalov <a.beregalov@gmail.com>:
>>> 2009/4/2 Theodore Tso <tytso@mit.edu>:
>>>> On Thu, Apr 02, 2009 at 02:53:51AM +0400, Alexander Beregalov wrote:
>>>>> On Thu, Apr 02, 2009 at 01:23:28AM +0400, Alexander Beregalov wrote:
>>>>>> Hi Theodore, Jens
>>>>>>
>>>>>> kernel is 2.6.29-07099-g8b53ef3
>>>>>>
>>>>>> Mount failed:
>>>>>>
>>>>>> EXT4-fs: barriers enabled
>>>>>> kjournald2 starting: pid 1867, dev loop0:8, commit interval 5 seconds
>>>>>> EXT4-fs error (device loop0): ext4_iget: block reference 2703228928 >=
>>>>>> max (524288) in inode #2, offset=0
>>>>>> EXT4-fs: get root inode failed
>>>>>> EXT4-fs (device loop0): mount failed

This message indicates that the inode contains a reference to a block
outside the filesystem at inode->i_data[0].

When I added the block range checks, initially I was assuming that
when EXTENTS_FL is not set, the inode->i_data *always* contains
references to further blocks.  Ted showed me wrong and added the condition

	ISREG() || ISDIR() || ( ISLNK() && !is_fast_symlink() )

before that assumption can be made.  But maybe we need some further
restraints?

Kind regards,

Thiemo
