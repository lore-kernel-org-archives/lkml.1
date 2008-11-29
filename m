Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYK2K02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYK2K02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYK2K0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:26:19 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:50730 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYK2K0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:26:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=INERwIpAoh1WjAYv1wjYcn3qqGriiL54VzJM7cMX6Kd6xCj+7A9y93jukiEATnAR4J
         13gRQnfftS4h7Niutl7JUKkrmfTJCzQtdEz1QjsziXvlZZulQJ2I7BTe/5fGNcGCSHaj
         dp04JC42jfd0c/4UG4c/Nfz6Mqti03oY7GSeM=
Date: Sat, 29 Nov 2008 19:26:10 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081129192610.716a2d57.h.mitake@gmail.com>
In-Reply-To: <20081129093858.GC26691@elte.hu>
References: <200811290056.mAT0uTuk028924@terminus.zytor.com>
	<20081129164736.0b5a71db.h.mitake@gmail.com>
	<20081129093858.GC26691@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 10:38:58 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Hitoshi Mitake <h.mitake@gmail.com> wrote:
> 
> > +#define readq readq
> > +#define writeq writeq
> 
> hm, that's done to override the generic definition? Looks weird and i 
> think that's rather fragile - it's easy to somehow get the generic header 
> without this override.

No, the purpose of this #define is to let user of this function to know there's readq/writeq.
Like this,

#ifdef readq
/* do something */
#endif

But this is old way. ARCH_HAS_READQ and ARCH_HAS_WRITEQ are new ways
to determine existence of readq/writeq. Drivers which use readq/writeq should
depend on these values in their Kconfig file.

This definitions may be redundant. But there are some architectures
which already have this definition for same purpose. So I added.

Should I remove these?
