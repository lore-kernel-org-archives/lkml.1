Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZADOY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZADOY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 09:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZADOYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 09:24:47 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:14090 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZADOYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 09:24:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Ujz49SxU6+jBIwWN03DFCS9GeiVdFHZ+N8bNAun6z4YPpU4KrYj48tvOHRSvYNoys0
         6PlxncdorwXpl6DRVG68fuB+Hcu+ktf3bPbRjwfuNgSfySUhO086/PvS89JaCzOQMao4
         lSHVfM+JnH7iMfXgrHFSy5bUqKWyJarE/n/AM=
Message-ID: <e9e943910901040624y69c01b43p1655c0078b969ea6@mail.gmail.com>
Date: Sun, 4 Jan 2009 14:24:43 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: document ext3 requirements
Cc: "=?WINDOWS-1252?Q?Martin_MOKREJ=8A?=" 
	<mmokrejs@ribosome.natur.cuni.cz>,
       "Pavel Machek" <pavel@suse.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
In-Reply-To: <15786.1231041158@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090103123813.GA1512@ucw.cz>
	 <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>
	 <20090103222957.GG1666@elf.ucw.cz>
	 <495FEE66.9080903@ribosome.natur.cuni.cz>
	 <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com>
	 <495FF9CE.2020908@ribosome.natur.cuni.cz>
	 <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com>
	 <495FFECB.5040001@ribosome.natur.cuni.cz>
	 <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com>
	 <15786.1231041158@turing-police.cc.vt.edu>
X-Google-Sender-Auth: 25b6d5a2effcafbf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/4  <Valdis.Kletnieks@vt.edu>:
> On Sun, 04 Jan 2009 00:41:51 GMT, Duane Griffin said:
>
>> I agree, it isn't a great situation. Nonetheless, it has always been
>> thus for ext3, and so far we've muddled along. Unless and until we can
>> replay the journal in-memory without touching the on-disk data, we are
>> stuck with it.
>
> Is there a way using md/dm/lvm etc to make the source partition R/O and
> replay the journal onto a CoW snapshop?  Admittedly, not easy to do inside
> the 'mount' command itself, but at least it might be workable for LiveCD R/O
> mounts and forensics work, where you can *tell* beforehand that's what you
> want and can jump through setup games before doing the mount...

Yes, something like that is best practice, as I understand it. The
LiveCD init scripts could check whether they are about to R/O mount an
ext[34] filesystem needing recovery and either refuse with a useful
message to the user, or even automatically create and mount a COW
snapshot, as you described. They'd still need to warn the user though,
since things like remounting R/W wouldn't work as expected.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
