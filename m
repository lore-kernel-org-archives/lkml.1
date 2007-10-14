Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbXJNMmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbXJNMmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 08:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbXJNMmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 08:42:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60508 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbXJNMmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 08:42:44 -0400
Date: Sun, 14 Oct 2007 14:42:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bauke Jan Douma <bjdouma@xs4all.nl>
cc: vignesh babu <vigneshbabu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: wierd file perms
In-Reply-To: <47120BC9.2060008@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0710141440570.22801@fbirervta.pbzchgretzou.qr>
References: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com>
 <20071013172848.GE16774@lug-owl.de> <47120BC9.2060008@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 14 2007 14:30, Bauke Jan Douma wrote:
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
> I don't think this is a bug, but a feature of 'ls', see for instance
> the coreutils mailing list:
>
> http://lists.gnu.org/archive/html/bug-coreutils/2007-05/msg00226.html

- broken on-disk fs
- you are not allowed to stat() -- which can only reasonably happen
  with FUSE or remote filesystems
- ls also outputs ?--------- if the file mode does not make sense,
  though as we can see, UID/GID nlink, etc. are also missing, so I suspect
  item 2.

