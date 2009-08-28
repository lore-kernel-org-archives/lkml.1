Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZH1VHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZH1VHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZH1VHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:07:00 -0400
Received: from web45215.mail.sp1.yahoo.com ([68.180.197.176]:24280 "HELO
	web45215.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750984AbZH1VG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:06:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=GAXVFDHW9opHmafdH1bKEm3Sjcj3GJtVjiradSkHnl28009OM4hRpPukv9oEcOcrVEkcoNnQygBvwX79ETTgCbM9J0Do80UZg4DQkt22NL6E/fsttSSyTPIKu+FVoIK03YjbrBjDXjQaQn4JpYtZkBFQcY1CrW2+6XbJhXSk0lc=;
Message-ID: <989804.72681.qm@web45215.mail.sp1.yahoo.com>
X-YMail-OSG: z2R922MVM1mYVaOR22s9fcwzrmt8ScME6V3sJNSB0BytJ5j_67ySr7GdGlLEi.Au_ddMJSdGPNibje314kD4x3Gn2HKsfZJLekF28nxU5J.Bbl_g8anhjSNrUFQe0wEspLYd_.vxxJfAcpz.ssZbJ3l2xeHTKvCkArDSIiZomOYcs_unE0fmfsCRy8WKXlx9KTMRCeg8sATaK3hkOd_a3cdj_ke0OdN5cCLDJbNn5UYGM_4-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Fri, 28 Aug 2009 14:07:01 -0700 (PDT)
From: joe Shmoe <jsmoe3@yahoo.com>
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
In-Reply-To: <20090828205337.3677cf04@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

doesn't CR3 gets reloaded for process switch? If so , how does it matter if you setup page table mapping for all the available RAM instead of limiting to just 1GB

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


      
