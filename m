Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYCZR4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYCZR4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbYCZRzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:55:50 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:15040 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955AbYCZRzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MO+FmaE7Ccv+e9lEda7/nzNKnalnsLFiYQ6jCSxfZnKt6TiOWtYZuOpyh2sXz9qlBjlkOCIXyiuF/mK6b743zh4w/gP51DuiADxj1gNc/WrITxXUbwtNHCcgzECGBEFZ5zhLYIuzFh4nGicrxMyEoeGJKTPsLeQjYYEgsiP592E=
Message-ID: <cdac42810803261055wdfef4c7ifb3ec0266bbd9ac0@mail.gmail.com>
Date: Thu, 27 Mar 2008 01:55:47 +0800
From: "bbb arc" <arcbbb@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: problem with userland exec()
In-Reply-To: <93517968-4587-4045-853a-70d2702f11a3@d21g2000prf.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <93517968-4587-4045-853a-70d2702f11a3@d21g2000prf.googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i am trying grugq's userland exec()  [1]
 but is unable to run with my simple static linked hello world program
 [2]

 because of the random stack start address,I tried added the following
 three lines in the
 save.c:ul_setup_stack():

    stack_top = mmap(0,0x16000, PROT_WRITE |PROT_READ,
                MAP_PRIVATE|MAP_ANONYMOUS|MAP_GROWSDOWN,-1,0);// test
    stack_top +=0x16000;

 the program still segmentation fault at memcpy: 0x804d95f:      rep
 movsl %ds:(%esi),%es:(%edi)

 Does anyone have ideas about it?

 Kind Regards,
 arcbbb

 [1] http://www.phrack.org/issues.html?issue=62&id=8
 [2] my simple hello world compiled with gcc -g -static
     #include <unistd.h>
     #define hello   "Hello World!\n"

     int
     main(void)
     {
             write(1, hello, 13);
             return (0);
     }
