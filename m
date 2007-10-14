Return-Path: <linux-kernel-owner+w=401wt.eu-S1763265AbXJNUCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763265AbXJNUCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXJNUBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:01:50 -0400
Received: from rtr.ca ([76.10.145.34]:2671 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759123AbXJNUBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:01:50 -0400
Message-ID: <471275AB.7090502@rtr.ca>
Date: Sun, 14 Oct 2007 16:01:47 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: vignesh babu <vigneshbabu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: wierd file perms
References: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com> <20071013172848.GE16774@lug-owl.de> <47121943.2030902@rtr.ca> <Pine.LNX.4.64.0710141602520.22801@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710141602520.22801@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 14 2007 09:27, Mark Lord wrote:
>> Jan-Benedict Glaw wrote:
>>> On Sat, 2007-10-13 22:40:23 +0530, vignesh babu <vigneshbabu@gmail.com>
>>> wrote:
>>>> I was surprised and did an ls -l on the files and guess what I found:
>>>>
>>>> total 0
>>>> ?--------- ? ? ? ?                ? fcntl.c
>>>> ?--------- ? ? ? ?                ? fifo.c
>>>> ?--------- ? ? ? ?                ? filesystems.c
>>>> ?--------- ? ? ? ?                ? file_table.c
>>>> ?--------- ? ? ? ?                ? freevxfs
>>>>
>>>> So end result is that, Im not able to delete the files or change perms
>>>> or ownership even as root.
>>> Most probably, your filesystem is broken and needs a fsck.
>> No, this is perfectly normal behaviour, for when a directory
>> has READ permissions but not EXECUTE permissions.
> 
> Er, close.
> 
> 	16:02 ichi:/dev/shm > md a
> 	16:02 ichi:/dev/shm > touch a/b
> 	16:02 ichi:/dev/shm > chmod 644 a
> 	16:02 ichi:/dev/shm > ls -l a
> 	/bin/ls: cannot access a/b: Permission denied
> 	total 0
> 	-????????? ? ? ? ?            ? b
> 	16:02 ichi:/dev/shm > ls --version
> 	ls (GNU coreutils) 6.9
> 
> 
> There is a difference ..  "-?????????" vs "?---------".

That's just a version difference for GNU ls.
Here, with ls (GNU coreutils) 5.97 it gives this:

?--------- ? ? ? ?                ? a/b


