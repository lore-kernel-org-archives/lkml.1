Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbXJNOFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbXJNOFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 10:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbXJNOFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 10:05:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36721 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbXJNOFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 10:05:03 -0400
Date: Sun, 14 Oct 2007 16:05:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mark Lord <lkml@rtr.ca>
cc: vignesh babu <vigneshbabu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: wierd file perms
In-Reply-To: <47121943.2030902@rtr.ca>
Message-ID: <Pine.LNX.4.64.0710141602520.22801@fbirervta.pbzchgretzou.qr>
References: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com>
 <20071013172848.GE16774@lug-owl.de> <47121943.2030902@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 14 2007 09:27, Mark Lord wrote:
> Jan-Benedict Glaw wrote:
>> On Sat, 2007-10-13 22:40:23 +0530, vignesh babu <vigneshbabu@gmail.com>
>> wrote:
>> > I was surprised and did an ls -l on the files and guess what I found:
>> >
>> > total 0
>> > ?--------- ? ? ? ?                ? fcntl.c
>> > ?--------- ? ? ? ?                ? fifo.c
>> > ?--------- ? ? ? ?                ? filesystems.c
>> > ?--------- ? ? ? ?                ? file_table.c
>> > ?--------- ? ? ? ?                ? freevxfs
>> >
>> > So end result is that, Im not able to delete the files or change perms
>> > or ownership even as root.
>> 
>> Most probably, your filesystem is broken and needs a fsck.
>
> No, this is perfectly normal behaviour, for when a directory
> has READ permissions but not EXECUTE permissions.

Er, close.

	16:02 ichi:/dev/shm > md a
	16:02 ichi:/dev/shm > touch a/b
	16:02 ichi:/dev/shm > chmod 644 a
	16:02 ichi:/dev/shm > ls -l a
	/bin/ls: cannot access a/b: Permission denied
	total 0
	-????????? ? ? ? ?            ? b
	16:02 ichi:/dev/shm > ls --version
	ls (GNU coreutils) 6.9


There is a difference ..  "-?????????" vs "?---------".

The first looks to me like "filetype known (S_IFREG)",
while the latter is "filetype and mode unknown".


