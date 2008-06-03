Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbYFCVbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbYFCVbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYFCVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:31:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:38043 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYFCVbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bd8Hah84++kGbDifd9Lc8cIVXc8EN27S4Rz0A03nZca2Yz8aFKRnxLC2qkWeZBYfO6112B5RI994oxvbCUIlkcGwND79ALg6xsFYYs61iZ2nlqK0Ncowj9OuoCg7OkKrqkks3z4S0fKPOFfWK4VtF+drAwqfZzr0YzkqWIvcdnA=
Message-ID: <e9e943910806031431r46f6c56fn1974b28e9aefd6ce@mail.gmail.com>
Date: Tue, 3 Jun 2008 22:31:43 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Andreas Dilger" <adilger@sun.com>
Subject: Re: Correct EXT3_TOPDIR_FL behaviour
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080603205220.GG2961@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e9e943910806021727h111b0e57qeea0032d164e0ffb@mail.gmail.com>
	 <20080603205220.GG2961@webber.adilger.int>
X-Google-Sender-Auth: 121d63f807ff9bc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/3 Andreas Dilger <adilger@sun.com>:
> On Jun 03, 2008  01:27 +0100, Duane Griffin wrote:
>> I'm looking at http://bugzilla.kernel.org/show_bug.cgi?id=9866, where
>> the reporter is claiming that EXT3_TOPDIR_FL (chattr +T) is behaving
>> incorrectly by being inherited from the parent. As mentioned in the
>> bug, it also only seems to only make sense for directories but
>> ext{2,3,4} is happy to set it on anything. It seems to me that the
>> reporter is correct and the behaviour should be changed to prevent the
>> flag being inherited and to limit it to directories only. If there is
>> no disagreement I'll follow-up with patches accordingly.
>
> Yes, this is a problem that was mentioned previously, and hasn't been
> fixed yet.  The TOPDIR_FL shouldn't be inherited, similar to the
> non-inheritance of INDEX_FL and EXTENTS_FL.
>
> It could be argued pretty easily that inheriting flags is usually wrong,
> and that we should instead specify which flags SHOULD be inherited,
> instead of repeatedly fixing bugs like this.

Right, I was wondering about the others.

> Flags that I would propose should be inherited from directories to
> regular files and subdirectories are: SECRM, UNRM, SYNC, APPEND, NODUMP,
> NOATIME, COMPR, NOCOMPR, JOURNAL_DATA, NOTAIL, and DIRSYNC, EXTENTS.
> I'm not sure what the semantics of IMMUTABLE on a directory are, whether
> it is even possible to create a new file in such a directory, but by
> principle of least surprise it should probably be inherited.
>
> Flags that definitely do not make sense to be inherited are: DIRTY, ECOMPR,
> INDEX, IMAGIC, TOPDIR, HUGE_FILE.
>
> Flags that don't make sense to be set on non-file/dir inodes are: DIRTY,
> ECOMPR, INDEX, SECRM, UNRM, SYNC, APPEND, COMPR, NOCOMPR, JOURNAL_DATA,
> NOTAIL, DIRSYNC, TOPDIR, EXTENTS, HUGE_FILE (used for files > 2TB).

OK, thanks. I'll fix these up at the same time then. At the moment,
for ext3, it seems INDEX is being cleared on everything, IMMUTABLE and
APPEND are being cleared on links, and DIRSYNC is cleared on
non-directories.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
