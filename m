Return-Path: <linux-kernel-owner+w=401wt.eu-S1030736AbXC2VRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030736AbXC2VRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030738AbXC2VRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:17:33 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39580 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030736AbXC2VRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:17:32 -0400
Date: Thu, 29 Mar 2007 14:17:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 1/4] coredump: add an interface to control the core dump
 routine
Message-Id: <20070329141715.71a6abae.akpm@linux-foundation.org>
In-Reply-To: <11911.1175195819@redhat.com>
References: <20070329104936.GC5138@ucw.cz>
	<45E7AAFA.4070402@hitachi.com>
	<45E7AC6F.8080704@hitachi.com>
	<20070302093419.GA2001@elf.ucw.cz>
	<4607C47B.2030909@hitachi.com>
	<11911.1175195819@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 20:16:59 +0100
David Howells <dhowells@redhat.com> wrote:

> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > Userland core dumper is useful because it is relatively easy to be
> > > customized, but its reliability highly depends on the application
> > > programs.
> > 
> > Fix userland core dumper to be reliable, then.
> 
> I don't think it's that easy.  The userland core dumper, as I understand it,
> has to work *within* an application program (it's a library), thus the
> application program my scotch the core dumper in a couple of ways:

That's no longer necessarily true with the recently-added
dump-to-an-application feature:

core_pattern:
  ...
. If the first character of the pattern is a '|', the kernel will treat
  the rest of the pattern as a command to run.  The core dump will be
  written to the standard input of that program instead of to a file.


That's new in 2.6.20 (maybe .19?) so people probably don't know about it.

