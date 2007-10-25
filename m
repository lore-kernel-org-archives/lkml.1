Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbXJYHMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbXJYHMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXJYHMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:12:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:15689 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbXJYHMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=h1eRLwIz4VbKEWQ6YTT3ttzCEIsuqJCJkzk1rfePe0Gc7L7CsRlsJYBI3LlydYvFNKLgGDTx2gVLDYCHi4ICixBioGqEA1WrhRM+5obm8FvB0jR3k9zUuTVTPu0BJ4xwS4YUBlN3MQVROHSk1X0/ImlmCmJ65W3Fc24GIO6QjDg=
Message-ID: <877aabc40710250012se0afe99s819207e72726d333@mail.gmail.com>
Date: Thu, 25 Oct 2007 12:42:04 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Jens Axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Panic in gart_map_sg
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: bc84281dd2d00bb2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get a kernel panic at gart_map_sg+0x201/0x470, which is around here:

	out++;
	flush_gart();
	if (out < nents) {
		sgmap = sg_next(sgmap);
		sgmap->dma_length = 0;
	}
	return out;

8e5:   e8 d6 fc ff ff          callq  5c0 <flush_gart>
 8ea:   ff c3                   inc    %ebx
 8ec:   41 39 df                cmp    %ebx,%r15d
 8ef:   0f 8e 9d 00 00 00       jle    992 <gart_map_sg+0x292>
 8f5:   31 c9                   xor    %ecx,%ecx
 8f7:   f6 45 00 02             testb  $0x2,0x0(%rbp)
 8fb:   0f 84 1f 02 00 00       je     b20 <gart_map_sg+0x420>
 901:   c7 41 18 00 00 00 00    movl   $0x0,0x18(%rcx)
 908:   e9 85 00 00 00          jmpq   992 <gart_map_sg+0x292>
 90d:   0f 1f 00                nopl   (%rax)
 910:   44 89 e0                mov    %r12d,%eax
 913:   29 f0                   sub    %esi,%eax
 915:   45 85 d2                test   %r10d,%r10d
 918:   89 c6                   mov    %eax,%esi
 91a:   0f 85 02 ff ff ff       jne    822 <gart_map_sg+0x122>
 920:   ff ce                   dec    %esi
 922:   75 65                   jne    989 <gart_map_sg+0x289>


My system is an AMD Opteron 1216. I'm not sure if only adding a check
for sgmap != NULL after sg_next is the right fix.

-- 
Amit Shah
http://www.amitshah.net/
