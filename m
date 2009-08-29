Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbZH2AUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbZH2AUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 20:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZH2AUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 20:20:30 -0400
Received: from web45202.mail.sp1.yahoo.com ([68.180.197.59]:41507 "HELO
	web45202.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751254AbZH2AU3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 20:20:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=btnQFpwZwe0fOzH6oYCfYZ+wEFvzY+m1SNObPExt8a4lhKPLWRLmwssSLJA4DpagjcPoi1CPvlIBBfr87A3cisRgoC7OBH8mTUToMKLI80R1pCRzBNddsNsQSUPLRHxj2WqEQDlOV9XNv13LQ6qcBk2512K8yqlsAK/M3vOC7Ws=;
Message-ID: <47584.30338.qm@web45202.mail.sp1.yahoo.com>
X-YMail-OSG: AjUPthAVM1nfOqvFh2d_pbXPBwyQG1Tq6SMc7u82ORxOdAFKx6TwkvjWINTzthEB7VIYOR0CPfWx1FcqQCdfzq1Bhg80matTZMU_jk55tCKH34kBCIsBlkoCGfMQkKVm1y5GP6PtLHtkTYMq5NMmwmoqH0_hHmv.XA_sepDNvPlGFAOjCnk3cWWn20z2kRwOXtge2j7IKRXZLfBwB3YMhoFnqzh81XsiFzocEjrdypgSGm4JD2xiBFrFNDRvjKtr.USjY279bJk-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Fri, 28 Aug 2009 17:20:31 -0700 (PDT)
From: joe Shmoe <jsmoe3@yahoo.com>
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090828231603.7918be05@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply Alan,
What I am looking for is this: Let us keep aside the virtual addresses for a process aside for a second. My question does not relate to that at all.

why does kernel map only 896MB of RAM to linear addresses in kernel page tables at the startup even if RAM size is more than that say 3.5GB of RAM
Why does it use dynamic memory mapping technique using zones for mapping the remaining 2.5 GB of RAM( 3.5GB - 1GB = 2.5GB)

Why not it does the following?
kernel sets up the page tables during initialization phase such that it maps all the available physical RAM i.e 3.5GB to linear addresses.
what is wrong with this approach. 




--- On Fri, 8/28/09, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
> To: "joe Shmoe" <jsmoe3@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Date: Friday, August 28, 2009, 6:16 PM
> O> I understand the implications
> of reloading CR3. But once the page tables are  setup
> to map all the available physical RAM to virtual (linear)
> address it could be for eg. 1, 2, 3 or 4 GB how does it
> matter.
> 
> Where are you putting the user virtual addresses. User
> addresses don't
> map direct to physical addresses so you need both sets of
> translations at
> once
> 
> Right now you have
> 
> 0-3GB        MMU translations
> to arbitary basically random
> physical addresses (with many pages shared and some
> absent)
> 
> 3GB+        Physical mapping
> only accessible in kernel mode
> 
> If user applications ran with a 1:1 mapping of application
> space to
> physical addresses you would be fine - but they don't and
> it would be
> rather hard to run like that because you want page sharing,
> lazy unshare,
> vfork etc to all work.
> 


      
