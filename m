Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbZH1Sk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbZH1Sk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZH1Skz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:40:55 -0400
Received: from web45209.mail.sp1.yahoo.com ([68.180.197.122]:22923 "HELO
	web45209.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752021AbZH1Sky convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:40:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hTRv8ma8jyaSEESxWuzi/IU4cQSgiRFgv9JhQKeCDMaxRUZMVw06cfOGZwAewA4fFsM5VlBFRG4OzlMee+o19zXp/ke4PN9NV5togG2pWNWbew8s2dL2X0dufP7M0ykOk1uwwgTS+XRJGTyYK1k1QFiezMNfPVBPw6jjfdVCElE=;
Message-ID: <812804.57438.qm@web45209.mail.sp1.yahoo.com>
X-YMail-OSG: gjxCbKAVM1lokSSJYC2XSAXRbAu.gINzn2Jza.4DXxXYzYB1NDh_Ou511pYTVxvo7gR26WxqNfgNmsJxH_bagX3XXUAGx4p55maq..9Om65OYOCNW2vY71Ry93bvu_puqmaKXq_z787FQHe3Tw6YdEULPUhtkiSDfAjb8vJaWy2Z6f9yX_xlxY4ZbGTERdHhDTjd8.UpSPaCUCtLgkyKSE8-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Fri, 28 Aug 2009 11:40:56 -0700 (PDT)
From: joe Shmoe <jsmoe3@yahoo.com>
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ada8wh3renp.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply,
But my question is with regard to setting up the page tables during the kernel initialization in such a way so that entire RAM upto 4GB can be mapped. i.e virtual to physical address mapping. My question is strictly with reg. to physical address mapping only.

Why does kernel stop at 1GB (896 MB to be exact) while mapping from linear to physical address. 

Since a given process runs in both user/kernel mode how does it matter whether page table mapping  is for entire 4GB or 1 GB. Just because kernel setup the page tables does not mean that allocated dynamic memory cannot be accessed by given process while running in user mode. 


For the sake of discussion, let us say I have 3.5 GB of RAM of x86 with PAE disabled and I have only one process running other than kernel.
Why can't kernel simply setup the page table mapping in a way that entire 3.5GB is mapped from linear to physical during the initialization. Assuming this single process is given access upto 3 GB, while running in user mode this single process can access any memory location in the allocated 2 or 3 GB virtual space.






--- On Fri, 8/28/09, Roland Dreier <rdreier@cisco.com> wrote:

> From: Roland Dreier <rdreier@cisco.com>
> Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
> To: "joe Shmoe" <jsmoe3@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Date: Friday, August 28, 2009, 2:12 PM
> 
>  > Assuming I have 3GB RAM, why does not kernel create
> page tables in a way that all of this 3GB physical memory
> can be addressed . (for x86 arch 32 bit with PAE disabled )
>  > 
>  > I understand the 3GB/1GB split for user/kernel
> address space.Isn't  this just a matter of setting up the
> page table entries in such a way that so all the available
> RAM upto 3GB can mapped in the kernel page tables. In this
> way CPU's MMU can take care of mapping any virtual address
> within first 4GB to physical address using the page table
> entries regardless of a process is in kernel/user mode. 
> 
> On a 32-bit architecture, there is only 4GB of address
> space available.
> If the kernel uses 3GB of address space for a direct
> mapping of physical
> memory, then only 1GB is available for everything else
> (userspace,
> vmalloc, etc).  BTW, this is available by enabling
> CONFIG_VMSPLIT_1G.
> 
>  - R.
> 


      
