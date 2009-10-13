Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbZJMLgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbZJMLgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZJMLgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:36:08 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50457 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbZJMLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SQ++A9ie4r8RTwDx6whp5Ns4JkDNRxXdY7CW2dBLcTxvI+OFwTQf+U3RuSDmxVWKhY
         nwWbTJrkMdMOwQpAiMzOatwGB2ga+JE1GkKYAybjiH9JF3zyLKVaEUDrF4EWgHS20pKX
         qISPai0OEofbMqhD2O8Uc8VJowyXGYx7m57fY=
MIME-Version: 1.0
In-Reply-To: <20091013060312.GA3215@elte.hu>
References: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
	 <20091012213229.11898c12@infradead.org>
	 <20091013060312.GA3215@elte.hu>
Date: Tue, 13 Oct 2009 07:35:28 -0400
Message-ID: <817ecb6f0910130435q56fcbf63r82fae9b94f3eb199@mail.gmail.com>
Subject: Re: [PATCH V5] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Aristeu Rozanski <aris@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I like doing this, but... maybe it is useful to have a diff of the
>> pagetable dump (PT_DUMP config option) to show the effect, in the
>> changelog. That'd be like the proof on the pudding...
>
> That's a good suggestion. Siarhei Liakh, mind doing that?

Here you go:
===============================================
--- data_nx_pt_before.txt	2009-10-13 07:26:17.000000000 -0400
+++ data_nx_pt_after.txt	2009-10-13 07:26:46.000000000 -0400
@@ -2,12 +2,9 @@
 0x00000000-0xc0000000           3G                           pmd
 ---[ Kernel Mapping ]---
 0xc0000000-0xc0100000           1M     RW             GLB x  pte
-0xc0100000-0xc048d000        3636K     ro             GLB x  pte
-0xc048d000-0xc04d0000         268K     RW             GLB x  pte
-0xc04d0000-0xc04d2000           8K     RW             GLB NX pte
-0xc04d2000-0xc04d3000           4K     RW             GLB x  pte
-0xc04d3000-0xc0531000         376K     RW             GLB NX pte
-0xc0531000-0xc0600000         828K     RW             GLB x  pte
+0xc0100000-0xc0381000        2564K     ro             GLB x  pte
+0xc0381000-0xc048d000        1072K     ro             GLB NX pte
+0xc048d000-0xc0600000        1484K     RW             GLB NX pte
 0xc0600000-0xf7800000         882M     RW         PSE GLB NX pmd
 0xf7800000-0xf79fe000        2040K     RW             GLB NX pte
 0xf79fe000-0xf7a00000           8K                           pte
===============================================

Would you like me to re-post whole patch with this addition?

Thanks.
