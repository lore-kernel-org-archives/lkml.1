Return-Path: <linux-kernel-owner+w=401wt.eu-S1764376AbXJOB3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764376AbXJOB3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 21:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXJOB3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 21:29:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:29171 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbXJOB3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 21:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fKy9sTzis7CfENX4Jsum0FbGOzxcLPaUFF1EZWbEOXDR8mazfXnQmwEnVk3eUfSRKYQbYhme4gDHpf5YFI2zwPRXpG42vWgdZBd2+Or1puG+zVrI3e9++YyynTUi1pxGLhnbrVT1rIBpyBIKvbYdp7aP/SCffrDz2dSYzHWHlBQ=
Message-ID: <3d1754a30710141829y24e19e70o500e7bbb6bb56701@mail.gmail.com>
Date: Mon, 15 Oct 2007 06:59:20 +0530
From: "vignesh babu" <vigneshbabu@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: wierd file perms
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
In-Reply-To: <471275AB.7090502@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com>
	 <20071013172848.GE16774@lug-owl.de> <47121943.2030902@rtr.ca>
	 <Pine.LNX.4.64.0710141602520.22801@fbirervta.pbzchgretzou.qr>
	 <471275AB.7090502@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ls --version
ls (GNU coreutils) 5.97

An fsck did it :) and had the source restored by checkout -f

Think Jan is right, there is a diff between the two...

On 10/15/07, Mark Lord <lkml@rtr.ca> wrote:
> Jan Engelhardt wrote:
> > On Oct 14 2007 09:27, Mark Lord wrote:
> >> Jan-Benedict Glaw wrote:
> >>> On Sat, 2007-10-13 22:40:23 +0530, vignesh babu <vigneshbabu@gmail.com>
> >>> wrote:
> >>>> I was surprised and did an ls -l on the files and guess what I found:
> >>>>
> >>>> total 0
> >>>> ?--------- ? ? ? ?                ? fcntl.c
> >>>> ?--------- ? ? ? ?                ? fifo.c
> >>>> ?--------- ? ? ? ?                ? filesystems.c
> >>>> ?--------- ? ? ? ?                ? file_table.c
> >>>> ?--------- ? ? ? ?                ? freevxfs
> >>>>
> >>>> So end result is that, Im not able to delete the files or change perms
> >>>> or ownership even as root.
> >>> Most probably, your filesystem is broken and needs a fsck.
> >> No, this is perfectly normal behaviour, for when a directory
> >> has READ permissions but not EXECUTE permissions.
> >
> > Er, close.
> >
> >       16:02 ichi:/dev/shm > md a
> >       16:02 ichi:/dev/shm > touch a/b
> >       16:02 ichi:/dev/shm > chmod 644 a
> >       16:02 ichi:/dev/shm > ls -l a
> >       /bin/ls: cannot access a/b: Permission denied
> >       total 0
> >       -????????? ? ? ? ?            ? b
> >       16:02 ichi:/dev/shm > ls --version
> >       ls (GNU coreutils) 6.9
> >
> >
> > There is a difference ..  "-?????????" vs "?---------".
>
> That's just a version difference for GNU ls.
> Here, with ls (GNU coreutils) 5.97 it gives this:
>
> ?--------- ? ? ? ?                ? a/b
>
>
>


-- 

----------------------------------------------
"Why is it that every time I'm with you, makes me believe in magic?"
