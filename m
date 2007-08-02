Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbXHBWJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbXHBWJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXHBWIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:08:52 -0400
Received: from ozlabs.org ([203.10.76.45]:32942 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbXHBWIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:08:51 -0400
Subject: RE: scripts/mod/file2alias.c cross compile problem
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: trenn@suse.de, Adrian Bunk <bunk@stusta.de>,
       Sam Ravnborg <sam@ravnborg.org>, Jan Dittmer <jdi@l4x.org>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
In-Reply-To: <617E1C2C70743745A92448908E030B2A0211AFF0@scsmsx411.amr.corp.intel.com>
References: <617E1C2C70743745A92448908E030B2A0211AFF0@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 08:08:20 +1000
Message-Id: <1186092501.6131.154.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 09:25 -0700, Luck, Tony wrote:
> > Adrian Bunk: scripts/mod/file2alias.c is compiled with HOSTCC and ensures that
> > kernel_ulong_t is correct, but it can't cope with different padding on
> > different architectures.
> 
> Surely this is the root cause ... you can't expect that the alignment
> rules of HOSTCC to make any sense for an arbitraty target.
> 
> > +#define FILLUP_LEN	7 /* dirty fix for i386 -> 64bit cross-compilation */
> >  
> >  struct acpi_device_id {
> >  	__u8 id[ACPI_ID_LEN];
> > +	__u8 dummy[FILLUP_LEN];
> >  	kernel_ulong_t driver_data;
> >  };
> 
> What's so special about this structure that we get an error?

It's in mod_devicetable.h: see comment at top of that file.  These
structures serve dual purpose: to describe the capabilities of the
driver to the kernel probing functions, *and* to export them to
userspace tables.  The former purpose is why there's a data pointer in
there.

scripts/mod/file2alias is the program that reads this: although it can
be altered to parse 32-vs-64, Adrian's fix is the simplest.

Hope that clarifies,
Rusty.

