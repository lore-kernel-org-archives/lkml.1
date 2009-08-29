Return-Path: <linux-kernel-owner+w=401wt.eu-S1751765AbZH2Okd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbZH2Okd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 10:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZH2Okc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 10:40:32 -0400
Received: from web45216.mail.sp1.yahoo.com ([68.180.197.185]:45444 "HELO
	web45216.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751578AbZH2Okc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 10:40:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=SbHyjku1zgL8gWAtakYt/uLQ0fVjXoMIaAcXwzaMJbzdXTODK6mptol5+QY8GAxekCIMCKA+baOsnNxIK/Inb6E4OnBQ9C8ZCtkt2iWfM5eos8R9846EgjRauTe4625kLtmrNuZEa6T35tdSKF0cR9VJX7fbA2vCZEnF9aOYZHs=;
Message-ID: <477591.96177.qm@web45216.mail.sp1.yahoo.com>
X-YMail-OSG: OIRSy_0VM1lUtoFCK8akvttTGuVuCcV_hVslaKHhUTp4dW9mHXAXRG5Lsl3lxjfXYznX5PzCrWylrJQpodqQzOX77ev.tAL9HIoUuM4L6g4S25u4nbKN._GfEAn8MqlJ2UKJmNiHa8tkdxEq1J5Qi36gS32cvIJ5LimrqtQJfzaw9DM8LiV1EPfQj3ghFj4rvpdGrjvpBiVXgyfXo4rRI6Yq_Zq2c9KZC4TWbitFjmX64IwuJl5PYrJSRPJ5QGZJTPegdE6zEaU-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Sat, 29 Aug 2009 07:40:34 -0700 (PDT)
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

Hey Alan,
May be I confused you. Sorry

> 0-3GB        MMU translations
> to arbitary basically random
> physical addresses (with many pages shared and some
> absent)

Can those "arbitary basically random physical addresses" fall outside 
1GB-3GB is my question. Why does kernel stop at 896MB during page table setup. Why not go ahead and map the remaining available RAM (where RAM size is > 1GB < 4GB)
But kernel uses different technique for addressing the high memory > 896MB

Not sure this is being done so that it will be easier for kernel to maintain page table assignments/swaping to various processes.
 
> 3GB+        Physical mapping
> only accessible in kernel mode

Yes. This part I understand obviously these addresses are issued only when a process is running in kernel mode.


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


      
