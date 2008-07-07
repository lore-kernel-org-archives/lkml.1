Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYGGIGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYGGIGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 04:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYGGIGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 04:06:40 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:20856 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750934AbYGGIGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 04:06:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=NbE+sFPTGtYFEkfeGTj5ekl63D9zJfQ0cElvdWYXiBUjl+jVVQ6+BKKsgoX4e/whA9Ume6K4eUv06ZH/JsiRzTaZYJYSrd2ZZ5vKS1vte1tih7Z0zWFz7mWCn8b22OawdKJhU6xqgECqxTZ9LLrXilNcfa82y2WAzQrqt1fI2YQ=  ;
X-YMail-OSG: j5VV7KkVM1k9aDGKJxjXbvHl51FYHXM9yQ3JEDr2HGDiKr2RHvSVwQM7KYQCYznkE7uECDiVvFQkCknpU0dBLFI86lqOfdS8zGFJ_AXzONLXjZrctZUTIeMFs7347pqHndA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hugh Dickins <hugh@veritas.com>, benh@kernel.crashing.org,
       cotte@de.ibm.com
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
Date: Mon, 7 Jul 2008 18:06:10 +1000
User-Agent: KMail/1.9.5
Cc: Zan Lynx <zlynx@acm.org>, Ryan Hope <rmh3093@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com> <486E4FD8.4010102@acm.org> <Pine.LNX.4.64.0807042112130.16912@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0807042112130.16912@blonde.site>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_z5ccImvDsmKeFHj"
Message-Id: <200807071806.11630.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_z5ccImvDsmKeFHj
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 05 July 2008 06:29, Hugh Dickins wrote:
> On Fri, 4 Jul 2008, Zan Lynx wrote:
> > Ryan Hope wrote:
> > > I have tested this with 2.6.26-rc5-mm3 and with 2.6.26-rc8 w/ the
> > > get_user_pages_fast patches from -rc5-mm3... Xorg 1.4.99.* will start
> > > to load but hangs at a black screen. At this point, I can not switch
> > > to another tty. When I try pressing ctrl+alt+del the kernel ooopses
> > > and the caps lock led starts to blink. This happens using the nv,
> > > radeon and radeonhd drivers (the nv was tested on another box
> > > obviously). I have also tried to unselect HAVE_GET_USER_PAGES_FAST in
> > > my kernel config but this does not help. I can not figure out where or
> > > what the bug is. I can provide any other info you guys need to figure
> > > this out. Let me know what I can do.
> >
> > I think that I've seen this too on 2.6.26-rc8 on my laptop.  It's 64-bit
>
> Your attachment tells us it's actually 2.6.26-rc8-mm1, less of a worry.
>
> > AMD-64 single core (although I run a SMP-alternatives kernel on it) and I
> > was using the nv driver.
> >
> > The symptoms are the same.  Everything was working great until I started
> > X.  I SSH'd in and got the dmesg after X locked up.  The full dmesg and
> > config are attached because Thunderbird is a very stupid program and
> > won't let me paste without wrapping.
> >
> > Here is a bit of what I got though.
> >
> > [  269.224276] BUG: unable to handle kernel paging request at
> > ffffe20003480000 [  269.224291] IP: [<ffffffff80297e30>]
> > copy_page_range+0x520/0x760 [  269.224306] PGD 1102067 PUD 1103067 PMD 0
> > [  269.224315] Oops: 0000 [1] SMP
> >
> > [  269.224473] Call Trace:
> > [  269.224495]  [<ffffffff80239a9b>] dup_mm+0x26b/0x3c0
> > [  269.224507]  [<ffffffff8023a84c>] copy_process+0xc2c/0x1210
> > [  269.224518]  [<ffffffff8023aea3>] do_fork+0x73/0x310
> > [  269.224526]  [<ffffffff8024719e>] sys_rt_sigaction+0x8e/0xd0
> > [  269.224536]  [<ffffffff8020c2db>] system_call_after_swapgs+0x7b/0x80
> > [  269.224542]  [<ffffffff8020c5d7>] ptregscall_common+0x67/0xb0
>
> Useful info, thank you; even more useful was the Code line in your
> attachment
>
> > [  269.224557] Code: 00 00 48 b9 00 00 00 00 00 e2 ff ff 48 21 d8 48 c1
> > e8 0c 48 8d 14 c5 00 00 00 00 48 c1 e0 06 48 29 d0 48 01 c1 0f 84 10 ff
> > ff ff <48> 8b 01 48 89 ca f6 c4 40 74 04 48 8b 51 10 90 ff 42 08 90 ff
>
> which is enough to identify the oops as in copy_one_pte's get_page(page).
> Here's a patch I think we need, which I'm hoping will fix both your
> crashes - please let us know - thanks a lot.
>
> Stop mprotect's pte_modify from wiping out the x86 pte_special bit, which
> caused oops thereafter when vm_normal_page thought X's abnormal was normal.
>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Fix to 2.6.26-rc8-mm1 x86-implement-pte_special.patch
> Perhaps something similar needed for powerpc?  Nick will know.
>
>  include/asm-x86/pgtable.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- 2.6.26-rc8-mm1/include/asm-x86/pgtable.h	2008-07-03 11:34:55.000000000
> +0100 +++ linux/include/asm-x86/pgtable.h	2008-07-04 20:58:36.000000000
> +0100 @@ -57,7 +57,7 @@
>
>  /* Set of bits not changed in pte_modify */
>  #define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
> -			 _PAGE_ACCESSED | _PAGE_DIRTY)
> +			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY)
>
>  #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
>  #define _PAGE_CACHE_WB		(0)

I think we need a similar fix for s390 too. If so, then it really should
get into 2.6.26, but this late in the release, I hope an s390 maintainer
might be able to test and verify the fix?

Thanks,
Nick

--Boundary-00=_z5ccImvDsmKeFHj
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="s390-implement-pte_special-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="s390-implement-pte_special-fix.patch"

Stop mprotect's pte_modify from wiping out the s390 pte_special bit, which
caused oops thereafter when vm_normal_page thought X's abnormal was normal.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/include/asm-s390/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-s390/pgtable.h
+++ linux-2.6/include/asm-s390/pgtable.h
@@ -223,6 +223,9 @@ extern char empty_zero_page[PAGE_SIZE];
 #define _PAGE_SPECIAL	0x004		/* SW associated with special page */
 #define __HAVE_ARCH_PTE_SPECIAL
 
+/* Set of bits not changed in pte_modify */
+#define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_SPECIAL)
+
 /* Six different types of pages. */
 #define _PAGE_TYPE_EMPTY	0x400
 #define _PAGE_TYPE_NONE		0x401
@@ -681,7 +684,7 @@ static inline void pte_clear(struct mm_s
  */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	pte_val(pte) &= PAGE_MASK;
+	pte_val(pte) &= _PAGE_CHG_MASK;
 	pte_val(pte) |= pgprot_val(newprot);
 	return pte;
 }

--Boundary-00=_z5ccImvDsmKeFHj--
