Return-Path: <linux-kernel-owner+w=401wt.eu-S1030457AbXCSSEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457AbXCSSEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030461AbXCSSEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:04:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:34684 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030457AbXCSSEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=uPoGy36Uos7zdNGJXCmrJKtmAbtYXgpKSmTxOteZbVj/bh6hLNpOHX+k7i9jM3+6vCTQNpIq1C1R9Fb2hvRiN/Sbg/jEToZijJM7ksgNU6EWmr+0Sr6r1oq653jmEnMTJ42hIECja1fHSIAU3xIPamhPbh2lVd6YPdAKS2oSLro=
Message-ID: <45FED032.2000301@googlemail.com>
Date: Mon, 19 Mar 2007 19:02:26 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>	 <45FD8684.4030501@googlemail.com>	 <6bffcb0e0703190845s6bdc1a65p71937d1dffbf6d9e@mail.gmail.com>	 <Pine.LNX.4.64.0703191751560.21196@sbz-30.cs.Helsinki.FI>	 <6bffcb0e0703190929rd118b16u21552da0c81b9f04@mail.gmail.com>	 <Pine.LNX.4.64.0703191836370.22180@sbz-30.cs.Helsinki.FI>	 <6bffcb0e0703190945i5f783ea9ie8195fa084b2c13f@mail.gmail.com> <6bffcb0e0703191024w527638f8yacc3a8fea9fd451d@mail.gmail.com>
In-Reply-To: <6bffcb0e0703191024w527638f8yacc3a8fea9fd451d@mail.gmail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisał(a):
> On 19/03/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>> On 19/03/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
>> > On Mon, 19 Mar 2007, Michal Piotrowski wrote:
>> > > Yes, revoke-special-mmap-handling.patch is bad.
>> >
>> > Aah, the VM_REVOKED flag stomps on VM_CAN_INVALIDATE in -mm. Changing
>> > VM_REVOKED to 0x10000000 should fix it.
> 
> Unfortunately it doesn't. 0x10000000 is used by VM_CAN_NONLINEAR.
> 0x20000000 should be a better value.

Here is a tested patch.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Pekka J Enberg <penberg@cs.helsinki.fi>

--- linux-work1-clean/include/linux/mm.h	2007-03-19 18:52:28.000000000 +0100
+++ linux-work1/include/linux/mm.h	2007-03-19 18:23:04.000000000 +0100
@@ -173,7 +173,6 @@ extern int do_mprotect(unsigned long sta
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
-#define VM_REVOKED	0x08000000	/* Mapping has been revoked */
 
 #define VM_CAN_INVALIDATE 0x08000000	/* The mapping may be invalidated,
 					 * eg. truncate or invalidate_inode_*.
@@ -181,6 +180,7 @@ extern int do_mprotect(unsigned long sta
 					 * return with the page locked.
 					 */
 #define VM_CAN_NONLINEAR 0x10000000	/* Has ->fault & does nonlinear pages */
+#define VM_REVOKED	0x20000000	/* Mapping has been revoked */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
