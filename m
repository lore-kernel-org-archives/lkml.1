Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbZBZWB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbZBZWB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbZBZWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:01:18 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:57458 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbZBZWBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:01:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=HrVHji5kZbFfY6D3T4FpmNghV8jiIGiAg7pHsQ78zuT/dkdFtkYwJClkYcEuSvTUq+
         XOQYE7nBEieGjUXOg9H00tT3TrIB5dQVEsM0QfJCPMzd3mm88p+SKEXR354/qOI4Qf+q
         Q1YoHOjqah37h+z+tg36j1qMcFu/Y6ZnFN98Q=
MIME-Version: 1.0
In-Reply-To: <20090226205245.GM7227@mit.edu>
References: <b637ec0b0902251203i1fe5f081vfd06350dbf5060e9@mail.gmail.com>
	 <b637ec0b0902260118o19f74acal567440a6f049512@mail.gmail.com>
	 <20090226141946.GE7227@mit.edu>
	 <b637ec0b0902260638u2a07433ayf0ea56fd3e41ec5a@mail.gmail.com>
	 <20090226160829.GH7227@mit.edu>
	 <b637ec0b0902261242o55d67bd9m65a6f26dc8ce1b19@mail.gmail.com>
	 <20090226205245.GM7227@mit.edu>
Date: Thu, 26 Feb 2009 23:01:13 +0100
Message-ID: <b637ec0b0902261401p191b2a1fn75b29e99c9f03726@mail.gmail.com>
Subject: Re: Crash in 2.6.28.7 - ext4 related
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Fabio Comolli <fabio.comolli@gmail.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Feb 26, 2009 at 9:52 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Feb 26, 2009 at 09:42:15PM +0100, Fabio Comolli wrote:
>> It's my home directory and so I prefer not to share, sorry.
>
> No problem, I understand.

Thanks.

>
>> Anyway, it seems that after the removal of that (possibly corrupted)
>> directory, I can't reproduce the problem anymore. I tried to create
>> / modify / delete some big directories, even two or three at a time
>> with no luck.
>
> Did you ever try running e2fsck on the filesystem while you could
> reproduce it?  Did it report any errors?  A good thing to do in
> general, if you can report these sorts of problems, is to run e2fsck
> with the -n option, while the filesystme is unmounted, and see if any
> errors are reported.  That would tell us if there were any filesystem
> corruption problems (and the -n avoids making any changes to the
> filesystem).

OK, maybe I did not make myself clear in my previous post. After the
last crash (the one from which the picture was taken)  I booted
single-user and the I forced a full fsck with the filesystem
unmounted. It reported no errors. After that I removed the problematic
directory and all is fine since that.

Maybe it's worth mentioning that I did the very same actions after
another crash that happened before: also in that case a full fsck
reported no errors but trying to remove the directory after that
crashed the machine.

>
> Also, even if you don't feel willing to share the e2image file, if you
> can reproduce it, please consider making a raw e2image dump.  That way
> if the problem goes away again, maybe you'll be able to consistently
> report reproduce it on the e2image dump file.

Yup, will do if the problem shows up again.

>
> The other thing that you can do which will sometimes work is to add
> the -s option to the e2image command.  The -s option scrambles the
> name of the directory entries and zeros out any unused portions of
> directory blocks to prevent privacy problems.  The downside is that it
> can prevent certain bugs from being repeatable and you have to either
> turn off the dir_index feature or run e2fsck to fix up the htree since
> the filename hashes will be screwed up after the directory entries are
> scrambled.  So it's not ideal, but in cases where there are privacy
> issues, that can be helpful.

Will do.

>
> Regards,
>
>                                        - Ted
>

Regards,
Fabio
