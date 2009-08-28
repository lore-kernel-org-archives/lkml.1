Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZH1UXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZH1UXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZH1UXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:23:22 -0400
Received: from web45216.mail.sp1.yahoo.com ([68.180.197.185]:37913 "HELO
	web45216.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752055AbZH1UXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:23:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=o3WYGItRbk2NQgHPU9MqcCZqD4TRQXULaHYh52q1PMKDu6C/FOdxxkUBiq5Rb0qHn7m1+XIkQR3an0rcQdlD2k2c8FtxoFeln5NtxSJr/8/1pvruJJbUESjumj6OL1OnqfWULQnIWoBWB0ELnC0OCwbimwgXY78GV+prAJRKLRo=;
Message-ID: <205.26101.qm@web45216.mail.sp1.yahoo.com>
X-YMail-OSG: 4oy7O04VM1n4mhbOVf8BEy_4J5raGtI4zVMyFUDhvHaTed6RZxRL4nPuSi5Yzvh0IxwElROtZdzWZ_IQ6uwvZOALtsqeyHwkcO7NH.1pIb8uC3ZSsOWCkRPEolsfNshgG7avJihKBAroan83ONgwldj5XR96HMdREEPV0gWBMKt644pTEBjZwqPTQveF_OrliOv0treTOOPlSfetbaJfFZrcQTxhL3LrcSp8.NkAy2cF6W7ljnVgxQ--
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Fri, 28 Aug 2009 13:23:23 -0700 (PDT)
From: joe Shmoe <jsmoe3@yahoo.com>
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090828205337.3677cf04@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>That however means reloading %cr3 (page table base) which is very
>expensive, and some very hard to implement locking on user space access

I understand the implications of reloading CR3. But once the page tables are  setup to map all the available physical RAM to virtual (linear) address it could be for eg. 1, 2, 3 or 4 GB how does it matter.

Now If a process wants to access a memory location which is above 1GB , since kernel already setup the page tables CPU MMU will do the translation since it consults this page table setup by kernel. Of course it also makes sure the page table has appropriate privilege level for access.

Am I missing something here?

 



--- On Fri, 8/28/09, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
> To: "joe Shmoe" <jsmoe3@yahoo.com>
> Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
> Date: Friday, August 28, 2009, 3:53 PM
> On Fri, 28 Aug 2009 12:44:25 -0700
> (PDT)
> joe Shmoe <jsmoe3@yahoo.com>
> wrote:
> 
> > No I am not talking about embedded systems. It is just
> an example.
> > My question is what is preventing the kernel from
> setting up the page tables so that entire RAM can be mapped
> upto 4 GB.
> 
> The design of the x86 processor
> 
> You only have 4GB of virtual address space at any one time
> so you have to
> fit the following within your 4GB virtual space
> 
> - Virtual addresses of the user space
> - Mappings for physical memory
> - Kernel virtual spaces (vmalloc etc)
> - Various miscellaneous kernel mappings
> - I/O MMIO space
> 
> Now you could in theory switch the page tables on kernel
> entry to get a
> very big user space mapping and then instead of relying on
> the user space
> being mapped you could map specific user pages or access
> them via their
> physical address lookup.
> 
> That however means reloading %cr3 (page table base) which
> is very
> expensive, and some very hard to implement locking on user
> space access.
> 
> Some other processor families have the notion of "spaces"
> or MMU
> bypassing. The Sparc64 for example can access MMIO space
> without an MMU
> mapping or virtual address being needed for it. x86 does
> not - it has
> segments but the segments map into the 4GB space so they
> don't help here
> hence the current implementation and 3G/1G split.
> 


      
