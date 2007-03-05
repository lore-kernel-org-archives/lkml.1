Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbXCETEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbXCETEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbXCETEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:04:12 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45469 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbXCETEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:04:10 -0500
X-AuditID: d80ac287-9d799bb000002978-e9-45ec69a99137 
Date: Mon, 5 Mar 2007 19:04:11 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: David Howells <dhowells@redhat.com>
cc: Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared
 memory 
In-Reply-To: <29317.1172931029@redhat.com>
Message-ID: <Pine.LNX.4.64.0703051843030.10272@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com> 
 <20070216165042.GB409@lnx-holt.americas.sgi.com> <45D5B483.3020502@hitachi.com>
 <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com>
 <18817.1171656543@redhat.com>  <29317.1172931029@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 05 Mar 2007 19:04:08.0843 (UTC) FILETIME=[0D9C65B0:01C75F59]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007, David Howells wrote:
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > > VMAs are a shared resource under NOMMU conditions.
> > 
> > That's a disturbing remark.
> 
> Why?  No-one complained when I first put up my rewrite patches three years ago.

Never mind whether anyone read your patches three years ago,
it's disturbing when one body of active developers perceives an object
as shared and another (largely disjoint) body of active developers
perceives it as private: great scope for disaster.

> 
> > Under precisely what NOMMU conditions?
> 
> CONFIG_MMU=n.

Believe it or not, I had just about grasped that subtlety.  I was
rather expecting some helpful response along the lines of "we share
all the vmas across a fork" or "whenever we go to allocate a vma, we
look to see if there's already an isomorphic vma which we can share"
or something like that.  But don't worry about it, the source is
there for me to look at whenever.

> 
> > I had thought Robin's suggestion very sensible; and throughout mm/
> > it has seemed pretty random whether we pass an "mm" argument down
> > in addition to "vma", or just take vma->vm_mm at whatever level needs.
> > 
> > You seem to be suggesting vma->vm_mm is dangerous when CONFIG_NOMMU,
> 
> vm_mm is never set to anything other than NULL if CONFIG_MMU=n and it doesn't
> seem to be a problem.  I don't think anything in the mm/ directory is left that
> looks at vm_mm once MMU support is disabled (in fact I've just checked, and I
> can compile with vm_mm #ifdef'd out)

That's reassuring, thanks.

> 
> > but we MMU people are scarily unaware of that.
> 
> If you're worryied that you can't compile anything for NOMMU, an FRV compiler
> is available, and a suitable NOMMU default config can be provided.
> Alternatively, you can pick ARM, M68K, ...
> 
> > Perhaps you need to put #ifndef CONFIG_NOMMU around vm_mm in struct
> > vm_area_struct?
> 
> I can if it makes you happier.  It's not strictly necessary, but it does make
> the struct smaller which is good.

No, it doesn't really make me any happier: I expect that if I look any
deeper, I'll just find plenty more to worry about there.  I have the
impression, now reinforced by your defensive posture, that NOMMU is
a hack that squeamish outsiders had better not look too deeply into:
so long as it mostly works for those who need it to work,
we'd probably just be wasting your time anyway.

Hugh
