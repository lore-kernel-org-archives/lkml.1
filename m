Return-Path: <linux-kernel-owner+w=401wt.eu-S1767291AbXDEUbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767291AbXDEUbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767303AbXDEUbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:31:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50762 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767301AbXDEUbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:31:11 -0400
Date: Thu, 5 Apr 2007 13:31:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
Message-Id: <20070405133109.fe416273.akpm@linux-foundation.org>
In-Reply-To: <7763.1175792579@turing-police.cc.vt.edu>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<7763.1175792579@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 13:02:59 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Mon, 02 Apr 2007 22:47:45 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> 
> Am seeing an Oops 'cannot handle kernel paging request' during late
> system startup, hand-copied traceback follows:
> 
> avc_has_perm_noaudit+0x2bf/0x506
> avc_has_perm+0x2b/0x5b
> selinux_socket_stream_connect+0x7e/0xc3
> unix_stream_connect+0x202/0x3f3
> sys_connect+0x7e/0xa4
> tracesys+0xde/0xe1
> 
> I've not identified exactly when it happens, but it's towards the very end of
> handling /etc/rc5.d, it's already up to the S98's.  Odd thing is it only happens
> when I start with RedHat's 'graphical boot', and may be related to the shutdown
> of the X server that's displaying the boot progress preparing to launch the
> X server for gdm logins (as I'm also seeing a hang sometimes when shutting
> down - so it is possibly a "shutting down X server nukes system" bug).

Thanks.

I'd have thought that the full trace could be captured with netconsole.

> Figured I'd toss this heads-up in case it rings any bells, while I go do
> the bisection dance on -rc5-mm4 (-mm2 is OK, and -mm3 doesn't boot for me
> for other reasons I didn't chase down before -mm4 came out and fixed it, so
> I have a ways to bisect)
> 

No, I'm not aware of anyone else hitting anything like that.

Bisection would be good, and probably pretty quick - I'd pick git-net.patch
as the first pivot point.

But we'd still be wanting the full trace if poss please.
