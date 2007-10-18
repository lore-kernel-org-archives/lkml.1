Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXJRRKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXJRRKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbXJRRKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:10:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58604 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbXJRRKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:10:20 -0400
Date: Thu, 18 Oct 2007 19:10:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: jaroslav.sykora@gmail.com
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Shadow directories
In-Reply-To: <200710181907.58643.jara@sin.cvut.cz>
Message-ID: <Pine.LNX.4.64.0710181908240.22233@fbirervta.pbzchgretzou.qr>
References: <200710181721.09201.jara@sin.cvut.cz>
 <Pine.LNX.4.64.0710181802300.2936@fbirervta.pbzchgretzou.qr>
 <200710181907.58643.jara@sin.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 18 2007 19:07, Jaroslav Sykora wrote:
>> On Oct 18 2007 17:21, Jaroslav Sykora wrote:
>> >Hello,
>> >
>> >Let's say we have an archive file "hello.zip" with a hello world program source
>> >code. We want to do this:
>> >	cat hello.zip^/hello.c
>> >	gcc hello.zip^/hello.c -o hello
>> >	etc..
>> >
>> >The '^' is an escape character and it tells the computer to treat the file as a directory.
>> 
>> But what you could do is: write a FUSE fs that mirrors the lower content
>> (lofs/fuseloop/however it was named) and expands .zip files as
>> directories are readdir'ed or the zip files stat'ed. That saves us
>> from cluttering up the Linux VFS with such stuff.
>
>Yes, that's exactly what RheaVFS and AVFS do. Except that they both use an escape
>character because:
>1. without it some programs may break [ http://lwn.net/Articles/100148/ ]
>2. it's very useful to pass additional parameters after the escape char to the server.
>
>We can start VFS servers (mentioned above) and chroot the whole user session into
>the mount directory of the server. It works but it's very slow, practically unusable.

Sounds like a program bug, since NTFS-3G is proof of concept that FUSE
can be fast.

>If anybody can think of any other solution of the "redirector
>problem", possibly even non-kernel based one, let me know and I'd be
>glad :-)
