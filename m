Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXDFTeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXDFTeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXDFTeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:34:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60347 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXDFTd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:33:59 -0400
Date: Fri, 6 Apr 2007 12:33:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
Message-Id: <20070406123355.a6f70a80.akpm@linux-foundation.org>
In-Reply-To: <4532.1175873184@turing-police.cc.vt.edu>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<7763.1175792579@turing-police.cc.vt.edu>
	<20070405133109.fe416273.akpm@linux-foundation.org>
	<4532.1175873184@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 11:26:24 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Thu, 05 Apr 2007 13:31:09 PDT, Andrew Morton said:
> > On Thu, 05 Apr 2007 13:02:59 -0400, Valdis.Kletnieks@vt.edu wrote:
> 
> > > Am seeing an Oops 'cannot handle kernel paging request' during late
> > > system startup, hand-copied traceback follows:
> > > 
> > > avc_has_perm_noaudit+0x2bf/0x506
> > > avc_has_perm+0x2b/0x5b
> > > selinux_socket_stream_connect+0x7e/0xc3
> > > unix_stream_connect+0x202/0x3f3
> > > sys_connect+0x7e/0xa4
> > > tracesys+0xde/0xe1
> 
> > Thanks.
> > 
> > I'd have thought that the full trace could be captured with netconsole.
> 
> I didn't have a second box available at first.  Then I blew close to 45
> minutes trying to figure out why netconsole was totally failing to work,
> before I found this in .config:
> 
> # CONFIG_NETCONSOLE is not set
> 
> "Do'h!" -- H. Simpson
> 
> Unfortunately, defining netconsole caused NETPOLL to be defined, which caused
> a recompile of half the known world, and the symptoms of the crash moved.
> 
> Film at 11, once I figure out what's going on, and fix the testbed in my
> office so I can actually catch this sucker - I may have to string a serial
> cable.  One solid good data point:
> 
> 21-rc5 with only the -mm4 'origin.patch' applied is OK, so whatever the
> issue is, it's not in Linus's tree.
> 

Oh well.  If it's all too much fuss, feel free to send the .config.  If it
happens on my machine(s) I can bisect it real quick.

