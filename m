Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZJAVu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZJAVu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZJAVu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:50:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:53256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbZJAVu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:50:56 -0400
Date: Thu, 1 Oct 2009 09:17:51 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: Add an extra bound check on ioctl arguments
Message-ID: <20091001091751.5e7c1782@infradead.org>
In-Reply-To: <20090930161316.96b5889e.akpm@linux-foundation.org>
References: <20090930131709.7300dff3@infradead.org>
	<20090930161316.96b5889e.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 16:13:16 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 30 Sep 2009 13:17:09 +0200
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > gcc is not convinced that the floppy.c ioctl has sufficient bound
> > checks,
> 
> gad.  You said "floppy" and "ioctl" in the same sentence.  Where
> angels fear to tread.

I have to admit I was very much not looking forward to working on this
warning, and made sure to wear protective clothing and that my
immunizations were up to date.
> 
> It would be useful if you were to quote the gcc output in the
> changelog please. 


In function ‘copy_from_user’,
    inlined from ‘fd_copyin’ at drivers/block/floppy.c:3080,
    inlined from ‘fd_ioctl’ at drivers/block/floppy.c:3503:
/home/arjan/linux/arch/x86/include/asm/uaccess_32.h:211:
warning: call to ‘copy_from_user_overflow’ declared with attribute
warning: copy_from_user buffer size is not provably correct

> I assume that you're using some magical new gcc
> option or something?

Not so much a new option, as using an option that has been there for a
while, and has been used extensively in userspace, just not yet in the
kernel. The patches are in the -tip tree, but if you want to take a
peek I can send them to you as well... they find some "interesting"
stuff.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
