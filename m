Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbYBROCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbYBROCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYBROBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:01:45 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60875 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbYBROBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:01:43 -0500
Date: Mon, 18 Feb 2008 15:01:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
Message-ID: <20080218140113.GA22098@uranus.ravnborg.org>
References: <20080207230304.GA4352@ghostprotocols.net> <p73ir0mxvby.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ir0mxvby.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 02:12:01PM +0100, Andi Kleen wrote:
> Arnaldo Carvalho de Melo <acme@redhat.com> writes:
> >
> > [acme@doppio net-2.6]$ l /tmp/sys_ia32.o.before /tmp/sys_ia32.o.after
> > -rw-rw-r-- 1 acme acme 185240 2008-02-06 19:19 /tmp/sys_ia32.o.after
> > -rw-rw-r-- 1 acme acme 248328 2008-02-06 19:00 /tmp/sys_ia32.o.before
> >
> > 	Almost 64KB only on this object file!
> 
> Just FYI, newer gcc does this in theory automatically when you specify 
> 
> -feliminate-unused-debug-types -feliminate-unused-debug-symbols
> 
> But in my tests on gcc 4.1 / gcc 4.2 it doesn't seem to make any difference
> currently :/ Not sure what is wrong. 
> 
> There is also -feliminate-dwarf2-dups, but it seems to even increase
> obj dir size. Also -feliminate-dwarf2-dups seems to generate a lot of 
> 
> WARNING: vmlinux.o (.gnu.linkonce.wi.mmzone.h.97561702): unexpected section name.
> The (.[number]+) following section name are ld generated and not expected.
> Did you forget to use "ax"/"aw" in a .S file?
> Note that for example <linux/init.h> contains
> section definitions for use in .S files.

Newly introduced consistency check. It immediately catched a few bugs
here and there not othing seriously. We could either restrict it to
known section names or just drop it again. At least it should not
be the reason to avoid using some good gcc feature.

	Sam
