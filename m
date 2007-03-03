Return-Path: <linux-kernel-owner+w=401wt.eu-S1030254AbXCCOK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254AbXCCOK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030257AbXCCOK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:10:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030254AbXCCOKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:10:55 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com> 
References: <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com>  <20070216165042.GB409@lnx-holt.americas.sgi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18817.1171656543@redhat.com> 
To: Hugh Dickins <hugh@veritas.com>
Cc: Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>, dhowells@redhat.com
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Sat, 03 Mar 2007 14:10:29 +0000
Message-ID: <29317.1172931029@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> > VMAs are a shared resource under NOMMU conditions.
> 
> That's a disturbing remark.

Why?  No-one complained when I first put up my rewrite patches three years ago.

> Under precisely what NOMMU conditions?

CONFIG_MMU=n.

> I had thought Robin's suggestion very sensible; and throughout mm/
> it has seemed pretty random whether we pass an "mm" argument down
> in addition to "vma", or just take vma->vm_mm at whatever level needs.
> 
> You seem to be suggesting vma->vm_mm is dangerous when CONFIG_NOMMU,

vm_mm is never set to anything other than NULL if CONFIG_MMU=n and it doesn't
seem to be a problem.  I don't think anything in the mm/ directory is left that
looks at vm_mm once MMU support is disabled (in fact I've just checked, and I
can compile with vm_mm #ifdef'd out)

> but we MMU people are scarily unaware of that.

If you're worryied that you can't compile anything for NOMMU, an FRV compiler
is available, and a suitable NOMMU default config can be provided.
Alternatively, you can pick ARM, M68K, ...

> Perhaps you need to put #ifndef CONFIG_NOMMU around vm_mm in struct
> vm_area_struct?

I can if it makes you happier.  It's not strictly necessary, but it does make
the struct smaller which is good.

David
