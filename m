Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbXLKTTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbXLKTTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbXLKTTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:19:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:58515 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXLKTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sPqzr96h/Uy+roummh5gGMHMvC0KsVV0mN40t4X2FyCNdqqek2+AWpyWdzh6UT8HvDdoqWA0WfVMhDnnI01FQOVHm8DG2lmaEUxqYQNfKEZ7KyYLY9nPJyJDwbJ/gEuOANh2ngguqS8VOwmoFWsa8Qi0kzUrq1UB7GJh2mRBGPA=
Subject: Re: [PATCH] x86: Unify mmap_{32|64}.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071211140830.GC12204@elte.hu>
References: <1196889830.10408.50.camel@brick>
	 <20071209081324.GB4509@elte.hu> <1197301855.1799.1.camel@brick>
	 <20071211083917.GB20172@elte.hu> <20071211104321.GA21513@elte.hu>
	 <Pine.LNX.4.64.0712111305000.12449@jikos.suse.cz>
	 <20071211140830.GC12204@elte.hu>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 11:19:42 -0800
Message-Id: <1197400782.8761.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-11 at 15:08 +0100, Ingo Molnar wrote:
> * Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > > hm, it fails to boot on Fedora 8:
> > >  Freeing unused kernel memory: 296k freed
> > >  Write protecting the kernel read-only data: 1500k
> > >  mount[623]: segfault at 0000000b ip 4d681ab6 sp bf9a1b94 error 6
> > >  modprobe[625]: segfault at 0000000b ip 4d681ab6 sp bffd9994 error 6
> > >  consoletype[629]: segfault at 0000000b ip 4d681ab6 sp bfb6ad14 error 6
> > >  awk[632]: segfault at 0000000b ip 4d681ab6 sp bffe68c4 error 6
> > >  fstab-decode[633]: segfault at 0000000b ip 4d681ab6 sp bff1c8c4 error 6
> > >  setsysfont[634]: segfault at 0000000b ip 4d681ab6 sp bfdd0f74 error 6
> > >  hwclock[637]: segfault at 0000000b ip 4d681ab6 sp bf963304 error 6
> > >  touch[642]: segfault at 0000000b ip 4d681ab6 sp bf98cb34 error 6
> > >  modprobe[651]: segfault at 0000000b ip 4d681ab6 sp bfbc0564 error 6
> > >  rhgb-client[654]: segfault at 0000000b ip 4d681ab6 sp bfe9c024 error 6
> > 
> > Ingo,
> > 
> > just for clarification -- this happens with Harvery's merged code 
> > (haven't looked at it yet), but not with the original code, do I 
> > understand it correctly?

Ingo,

Brown paper bag for me.

in mmap.c in mmap_is_ia32()

#ifdef X86_32

should of course be:

#ifdef CONFIG_X86_32

This would definitely explain the segfaults.  Do you want a replacement
patch or incremental?

Harvey

