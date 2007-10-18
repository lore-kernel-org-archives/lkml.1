Return-Path: <linux-kernel-owner+w=401wt.eu-S1765111AbXJRRIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765111AbXJRRIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbXJRRID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:08:03 -0400
Received: from services.sin.cvut.cz ([147.32.110.2]:33183 "EHLO
	services.sin.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbXJRRIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:08:01 -0400
From: Jaroslav Sykora <jara@sin.cvut.cz>
Reply-To: jaroslav.sykora@gmail.com
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC PATCH 0/5] Shadow directories
Date: Thu, 18 Oct 2007 19:07:58 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200710181721.09201.jara@sin.cvut.cz> <Pine.LNX.4.64.0710181802300.2936@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710181802300.2936@fbirervta.pbzchgretzou.qr>
X-Face: >I|[{8s3:Ic!^A\YY'ktAfvq]K.-@B=!>(:.VX7_KNlZ@`l)vxL}2g~)k(#@=?utf-8?q?BN=24U+3MgB2=0A=097yR=5D=26tZ8PTc=3D=60?=<A%=5!.VCQ~(<-2#;/xmM4t6'MB7zDSm7i$nn/x^TC*adoyqd"{b0,=?utf-8?q?Hr=5F=0A=09?=<.yl<O}[Z[s.oX/:P917[b9QB%3f]{m=`7azOx[(.XW)"nW?N]jA5=%!<=?utf-8?q?=27ayW=5E!NQg6RcZ=0A=09vG?=@\&{XT%rV)u^hXq%ecRC;$jLBaa>ZZB_o
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181907.58643.jara@sin.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 of October 2007, Jan Engelhardt wrote:
> 
> On Oct 18 2007 17:21, Jaroslav Sykora wrote:
> >Hello,
> >
> >Let's say we have an archive file "hello.zip" with a hello world program source
> >code. We want to do this:
> >	cat hello.zip^/hello.c
> >	gcc hello.zip^/hello.c -o hello
> >	etc..
> >
> >The '^' is an escape character and it tells the computer to treat the file as a directory.
> 
> Too bad, since ^ is a valid character in a *file*name. Everything is, with
> the exception of '\0' and '/'. At the end of the day, there are no control
> characters you could use.
> 
> But what you could do is: write a FUSE fs that mirrors the lower content
> (lofs/fuseloop/however it was named) and expands .zip files as
> directories are readdir'ed or the zip files stat'ed. That saves us
> from cluttering up the Linux VFS with such stuff.
> 

Yes, that's exactly what RheaVFS and AVFS do. Except that they both use an escape
character because:
1. without it some programs may break [ http://lwn.net/Articles/100148/ ]
2. it's very useful to pass additional parameters after the escape char to the server.

We can start VFS servers (mentioned above) and chroot the whole user session into
the mount directory of the server. It works but it's very slow, practically unusable.
So both servers need some kind of VFS redirector. In the past there were many
different approaches -- LD_PRELOAD hack, CodaFS hack, NFS hack (?), proof-of-concept
kernel hacks (project podfuk) etc.

If anybody can think of any other solution of the "redirector problem", possibly
even non-kernel based one, let me know and I'd be glad :-)

-- 
I find television very educating. Every time somebody turns on the set, 
I go into the other room and read a book.
