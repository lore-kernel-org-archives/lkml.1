Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYICFCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYICFCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 01:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYICFCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 01:02:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbYICFCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 01:02:45 -0400
Date: Tue, 2 Sep 2008 22:02:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [genksyms patch 3/4] Track symbol checksum changes
Message-Id: <20080902220231.0197237e.akpm@linux-foundation.org>
In-Reply-To: <20080721025913.063165574@suse.de>
References: <20080721022823.896799736@suse.de>
	<20080721025913.063165574@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 04:28:26 +0200 Andreas Gruenbacher <agruen@suse.de> wrote:

> Sometimes it is preferable to avoid changes of exported symbol checksums (to
> avoid breaking externally provided modules).  When a checksum change occurs, it
> can be hard to figure out what caused this change: underlying types may have
> changed, or additional type information may simply have become available at the
> point where a symbol is exported.
> 
> Add a new --reference option to genksyms which allows it to report why
> checksums change, based on the type information dumps it creates with
> the --dump-types flag.  Genksyms will read in such a dump from a previous run,
> and report which symbols have changed (and why).
> 
> The behavior can be controlled for an entire build as follows: If
> KBUILD_SYMTYPES is set, genksyms uses --dump-types to produce *.symtypes dump
> files.  If any *.symref files exist, those will be used as the reference to
> check against.  If KBUILD_PRESERVE is set, checksum changes will fail the
> build.

This breaks `make M=...'

With i386 allmodconfig,


akpm2:/usr/src/25> make M=drivers/rtc               

  WARNING: Symbol version dump /usr/src/devel/Module.symvers
           is missing; modules will have no dependencies and modversions.

  LD      drivers/rtc/built-in.o
  CC [M]  drivers/rtc/rtc-lib.o
scripts/genksyms/genksyms: invalid option -- r
Usage:
genksyms [-adDTwqhV] > /path/to/.tmp_obj.ver

  -a, --arch            Select architecture
  -d, --debug           Increment the debug level (repeatable)
  -D, --dump            Dump expanded symbol defs (for debugging only)
  -T, --dump-types file Dump expanded types into file (for debugging only)
  -w, --warnings        Enable warnings
  -q, --quiet           Disable warnings (default)
  -h, --help            Print this message
  -V, --version         Print the release version
make[1]: *** [drivers/rtc/rtc-lib.o] Error 1
make: *** [_module_drivers/rtc] Error 2
