Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbXEIXt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbXEIXt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbXEIXtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:49:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:54488 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbXEIXts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c8jriuAljpA13kxhy4Z0FtYg8WlsFHX80BMzCtAKiN/vg3/uVksH8bGjuldcmWsSJfuxnlf9Ncg0PQlqxiZcep80JZbQzfkO/WvlzndSL/pP7D/C/9xOuRMLjRtnELc+2mLJ1B0YiegTATJCFBtJCBjvhJCO3z6eL8D95SrySnM=
Message-ID: <787b0d920705091649m76d5f5f4m9768a6862b048659@mail.gmail.com>
Date: Wed, 9 May 2007 19:49:42 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Andrey Borzenkov" <arvidjaar@mail.ru>
Subject: Re: Long file names in VFAT broken with iocharset=utf8
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <200705091957.07557.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920705072143q63e56f23j18c6b0dbfb270883@mail.gmail.com>
	 <Pine.LNX.4.61.0705081036000.17280@yvahk01.tjqt.qr>
	 <787b0d920705090834p7ece0880n51d6e9288f307d1f@mail.gmail.com>
	 <200705091957.07557.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> On Wednesday 09 May 2007, Albert Cahalan wrote:
...
>>> On May 8 2007 00:43, Albert Cahalan wrote:

>>>> Fix: the vfat driver should use the 8.3 name for such files.
...
>> It's not appropriate for vfat, HPFS, JFS, or NTFS. All of those
>> have built-in support for 8.3 aliases. Normally the 8.3 names
>> are like hidden hard links, except that deletion of either name
>> will wipe out the other. (same as case differences too)
>> So the names are there, and they should already work.
>> They just need to be reported for directory listings when the
>> long names would be too long.
>
> several problems associated with it
>
> 1. those names are rather meaningless. How do you find out which file they
> refer to? It is OK for trivial cases but not in a directory full of long
> names; nor am I sure how many unique short names can be generated.

If a short name can not be generated, then no OS could
create the file at all. The vfat and iso9660 filesystems require
short names. Any OS writing to such a filesystem MUST
generate short names in addition to any long names.
Mount your vfat as filesystem type "msdos" to see.

By default, Windows will also generate short names on NTFS.

Note that you can't put your files on a CD-ROM in a way
that Windows could read the filenames. Windows limits
CD-ROM filenames to 63 characters; you get at most 103
if you violate the spec.

> 2. directory contents is effectively invalidated upon backup and restore (tar
> c; rm -rf; tar x). It is impossible to infer long names from short ones.

It may be that tar fails to use the vfat ioctl calls to save
and restore short names. You could try using Wine to
run a Windows-native backup program. This shouldn't
really matter though; you'd only be getting short names
for files that had truly unreasonable long names anyway.

I suppose somebody should check to see if there is a
danger of overwrite when the short-named files get
written back. The safest thing might be to mount the
filesystem as type "msdos".

> 3. this still does not answer how can I *create* long name from within Linux.

WTF? These names are too annoying to use, even if there
weren't this limit. Anything over about 29 characters is in
need of a rename. (that'd be 58 bytes for you, which is OK)
The limit is already 4 times larger than what is reasonable.
