Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab0CKOsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:48:17 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63190 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab0CKOsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:48:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OOeCfbKLTYMkovp1Gy2791vklAw1SrZVt4htd6dellkPdXST49X2q0n0zABO+v9Jl3
         8sxYn/c+xaxPk9JK0zi+r+QrOfB6Q8/rYVW6NuuaEx2zSdhu5gpix09Ikdt63Y2N019f
         OCHsDzfvLfKau9Rh/2QJIB5BiVF9E78NtA3LI=
MIME-Version: 1.0
In-Reply-To: <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu>
References: <4B947393.2050002@kernel.org> <4B97C6A5.4010209@tvk.rwth-aachen.de>
	 <17BB1CC0-9B13-401D-B6AA-90365208A042@mit.edu>
	 <201003111927.24829.knikanth@suse.de>
	 <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu>
Date: Thu, 11 Mar 2010 09:48:05 -0500
X-Google-Sender-Auth: b2b7f36447331134
Message-ID: <170fa0d21003110648y5c9738fcmeaee149ca3a831d3@mail.gmail.com>
Subject: Re: ATA 4 KiB sector issues.
From: Mike Snitzer <snitzer@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 9:28 AM, Theodore Tso <tytso@mit.edu> wrote:
>
> On Mar 11, 2010, at 8:57 AM, Nikanth Karthikesan wrote:
>>
>> I guess, what he meant was, to keep filesystem blocks aligned, even if the
>> partition is not. Say if the partition is mis-aligned by 512-bytes, let the
>> filesystem waste 4k-512bytes and keep it's blocks aligned. But it might be a
>> case of over-engineering, possibly requiring disk format change.
>
> Ah, yes, I agree with you; that's probably what he meant.
>
> Sure, that's theoretically possible, but it would mean changing every single filesystem, and it would require a file system format change --- or at least a file system format extension.
>
> It would seem to be way easier to simply fix the partitioning tools to do the right thing, though.

Yes, the current supported approach is to rely on partitions (parted,
fdisk) or LVM to account for 'alignment_offset'.

This avoids having a filesystem add its own padding (format change).
But e2fsprogs at least warns if a device, that it is to format, has an
alignment_offset != 0.

Mike
