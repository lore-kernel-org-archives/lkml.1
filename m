Return-Path: <linux-kernel-owner+w=401wt.eu-S933201AbXHFWea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbXHFWea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762549AbXHFWeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:34:21 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4818 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762271AbXHFWeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:34:20 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: 2.6.23-rc1-mm2
Date: Tue, 7 Aug 2007 00:34:18 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@suse.de, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-usb-devel@lists.sourceforge.net
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708062134.16643.m.kozlowski@tuxland.pl> <236b147ed4a92945baa3c6b29e7e5f31@kernel.crashing.org>
In-Reply-To: <236b147ed4a92945baa3c6b29e7e5f31@kernel.crashing.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708070034.19193.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> Second issue as reported earilier allmodconfig fails to build on imac
> >>> g3.
> >>>
> >>>   CC      arch/powerpc/kernel/lparmap.s
> >>>   AS      arch/powerpc/kernel/head_64.o
> >>> lparmap.c: Assembler messages:
> >>> lparmap.c:84: Error: file number 1 already allocated
> >>> make[1]: *** [arch/powerpc/kernel/head_64.o] Blad 1
> >>> make: *** [arch/powerpc/kernel] Blad 2
> >>
> >> Please send me the full output of:
> >>
> >> gcc --version    (or whatever your gcc is called)
> >> ld --version
> >> ld --help        (I know no better way to get the supported binutils
> >>                    targets, and the default target)
> >>
> >> and the lparmap.s file.  You might want to skip sending it
> >> to the lists, it will be a bit big (and off-topic on most
> >> of those lists, anyway).
> >
> > Well ... its 66kB. Not that bad. Please find it attached.
> > Needed gcc and ld info below.
> 
> Thanks.
> 
> It seems like things go wrong when lparmap.s is generated with
> (DWARF) debug info; could you try building it (manually) with -g0
> added on the end of the compile line, and see if head_64.o compiles
> okay for you then?  If so, I'll prepare a proper patch for it, I
> have a similar one (also for lparmap!) in my queue already...

Ok it worked. I had to add -g0 to Makefile under arch/powerpc/kernel because
-g0 was added before -g and didn't have any effect when adding to Makefile
in top dir. But yes - it compiles now.

Thanks,

	Mariusz
