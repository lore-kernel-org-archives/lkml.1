Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbYKRLfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbYKRLfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYKRLfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:35:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:11719 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYKRLfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:35:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wiEvy7+vEBVOC0UfcgYjmy0mEgubx8zo147IAe2hH7YpbM5/MUt9iG9ax234pIZRg4
         wnduL4s+Mbg5TQwDy9TbGM7LRpszUCF1DU10qQif9d68ICxQQ7MdLfqe3QOFZapyNTtY
         +4B332gAseKfDGLUD42P/9JGN+8zv+ciF7iMc=
Message-ID: <4104961b0811180335j2f0506bmcef515e070b08f14@mail.gmail.com>
Date: Tue, 18 Nov 2008 19:35:20 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: What's the difference between clear_page and clear_page_c?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

I saw there are clear_page and clear_page_c defined in
arch/x86/lib/clear_page_64.S, but what's the difference between these
two function? In addition, look at below lines copied from
linux-2.6.27-rc2, particularly line 16, is it a typo? I feel it should
be ENDPROC(clear_page_c) other than ENDPROC(clear_page), isn't it??

      4 /*
      5  * Zero a page.
      6  * rdi  page
      7  */
      8         ALIGN
      9 clear_page_c:
     10         CFI_STARTPROC
     11         movl $4096/8,%ecx
     12         xorl %eax,%eax
     13         rep stosq
     14         ret
     15         CFI_ENDPROC
     16 ENDPROC(clear_page)
     17
     18 ENTRY(clear_page)
     19         CFI_STARTPROC
     20         xorl   %eax,%eax
     21         movl   $4096/64,%ecx
     22         .p2align 4
     23 .Lloop:
     24         decl    %ecx
     25 #define PUT(x) movq %rax,x*8(%rdi)
     26         movq %rax,(%rdi)
     27         PUT(1)
     28         PUT(2)
     29         PUT(3)
     30         PUT(4)
     31         PUT(5)
     32         PUT(6)
     33         PUT(7)
     34         leaq    64(%rdi),%rdi
     35         jnz     .Lloop
     36         nop
     37         ret
     38         CFI_ENDPROC
     39 .Lclear_page_end:
     40 ENDPROC(clear_page)

Regards
Jason
