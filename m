Return-Path: <linux-kernel-owner+w=401wt.eu-S932900AbZADAmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbZADAmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZADAlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:41:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:64848 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZADAly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:41:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GzRnQgH0jGc/KwaTg5u6b3dSz/q0Cr0rNDWZlv0BYuA6cg7/lwAD5I8VVcFUTL2UFc
         SfxrFm8KDC5ha9AS7mdGDXK43c2FPrCOZGIc/fGiYj+DLE9ciwcma7W3osp17E5cHEXh
         Knp4KcNqpclTskWqoDwbkPFcCU0Xp5qYw58VA=
Message-ID: <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com>
Date: Sun, 4 Jan 2009 00:41:51 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "=?WINDOWS-1252?Q?Martin_MOKREJ=8A?=" 
	<mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: document ext3 requirements
Cc: "Pavel Machek" <pavel@suse.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
In-Reply-To: <495FFECB.5040001@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20090103123813.GA1512@ucw.cz>
	 <495FD5D7.2040907@ribosome.natur.cuni.cz>
	 <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>
	 <20090103222957.GG1666@elf.ucw.cz>
	 <495FEE66.9080903@ribosome.natur.cuni.cz>
	 <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com>
	 <495FF9CE.2020908@ribosome.natur.cuni.cz>
	 <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com>
	 <495FFECB.5040001@ribosome.natur.cuni.cz>
X-Google-Sender-Auth: 3efb4b380f00f268
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/4 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
> Duane Griffin wrote:
>> 2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
>>> Why does not "mount -ro" die when it would have to replay the journal
>>> with a message that user must run fsck.ext3 in order to be able to mount
>>> it albeit read-only? Still I would prefer having an extra switch to
>>> force mount RO while not touching the journal for disk forensics.
>>> I think that would also prevent the cases when a LiveCD/rescue distribution
>>> would not mount+replay it automagically but user would really have to
>>> provide the switch to the command. I am really not using the recovery
>>> boot cd to touch my partitions in some cases unwillingly.
>>
>> Well, that would make things rather tricky. As in, shutting down
>> uncleanly would render your system unbootable.
>
> ??? If I am booted off a CD/DVD drive I just do not want my system
> to be touched. I am fine if the dist mounts my drives automagically
> in read-only mode but if that currently forces journal replay then no,
> thanks. ;)

I agree, it isn't a great situation. Nonetheless, it has always been
thus for ext3, and so far we've muddled along. Unless and until we can
replay the journal in-memory without touching the on-disk data, we are
stuck with it.

We can't refuse to mount an unclean FS, as that would break booting.
We also can't ignore the journal by default, if/when we get a patch to
do so at all, as that effectively corrupts random chunks of the FS.
Fine for forensics and recovery; not so much for booting from.

> M.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
