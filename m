Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbYETQn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbYETQn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbYETQnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:43:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:29381 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbYETQnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EboKalDVt2jEieNiTH+hZ9Hl6JMMFtwfkUY0S88+y/avG482zl0QpTALMJiPj4zGuEyW5v2ryPCoyMxPSD82/EJGodwtqw2WTPfyRnH7ILU7qe8rdx4eX1RZdDZ2eIPsEvnEpv0trlUpmqtT09IYslDZSLt1EaY8GPpR6BG1JAA=
Message-ID: <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com>
Date: Tue, 20 May 2008 17:43:17 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: UML fails to locate address space
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080520161047.GA9598@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
	 <20080520135238.GB6990@c2.user-mode-linux.org>
	 <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com>
	 <20080520161047.GA9598@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Jeff Dike <jdike@addtoit.com>:
> On Tue, May 20, 2008 at 02:59:14PM +0100, Tom Spink wrote:
>> Attached.  I guess the line of interest is:
>>
>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = -1 EACCES (Permission
>> denied)
>
> Yup.
>
> Can you try three things:
>        check the maps file for any arbitrary process
> (i.e. /proc/$$/maps) and see if there's anything mapped at 0

Nothing.

>        gdb UML, stop it at that mmap, check its maps file and see if
> there's anything mapped at 0

Nope.

>        send me a pointer to the patches that Ubuntu has applied on
> top of the stock kernel - I'm suspicious that they special-cased page
> zero in order to ensure that NULL pointer dereferences cause faults.
>
> You can test this last theory by initializing bottom to 4096 instead
> of 0.

I suspected this type of foul-play, and tried altering bottom to 1,
but this didn't work.  So, I took out the page_ok test, and it
continued booting.  So I went back, put the test back in and
incremented bottom until I got to 16.  It worked at 16. :-)

Is this something that can be fixed, or would a config option be appropriate?

I am willing to blame Ubuntu, but unfortunately, I can't find an
online resource of their patches.

>                        Jeff
>
> --
> Work email - jdike at linux dot intel dot com
>

-- 
Tom Spink
