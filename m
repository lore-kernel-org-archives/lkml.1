Return-Path: <linux-kernel-owner+w=401wt.eu-S934327AbXC2TRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934327AbXC2TRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 15:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934328AbXC2TRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 15:17:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934327AbXC2TR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 15:17:29 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070329104936.GC5138@ucw.cz> 
References: <20070329104936.GC5138@ucw.cz>  <45E7AAFA.4070402@hitachi.com> <45E7AC6F.8080704@hitachi.com> <20070302093419.GA2001@elf.ucw.cz> <4607C47B.2030909@hitachi.com> 
To: Pavel Machek <pavel@ucw.cz>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       dhowells@redhat.com
Subject: Re: [PATCH 1/4] coredump: add an interface to control the core dump routine 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 29 Mar 2007 20:16:59 +0100
Message-ID: <11911.1175195819@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> > Userland core dumper is useful because it is relatively easy to be
> > customized, but its reliability highly depends on the application
> > programs.
> 
> Fix userland core dumper to be reliable, then.

I don't think it's that easy.  The userland core dumper, as I understand it,
has to work *within* an application program (it's a library), thus the
application program my scotch the core dumper in a couple of ways:

 (1) by trying to claim the same services (such as signal handlers).

 (2) by destroying the coredumper should the application run amok and splat it
     (by munmapping it, mmapping over it, writing over it, etc.).

Plus there are cases that an in-application userspace coredumper can't catch -
namely double/triple faults.

David
