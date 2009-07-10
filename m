Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZGJJr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZGJJr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZGJJrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:47:19 -0400
Received: from web15708.mail.cnb.yahoo.com ([202.165.102.75]:43357 "HELO
	web15708.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751078AbZGJJrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:47:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=sQB79+TM1WdE3ud/fzh0ZXE6SabT1S9sNUJ668bXVTDZFakcE3OVk9QfLSbYvoeQPBUPEpFq7Jq8jITVrek1B5tQLyqSwmA8Hzbmvmkl7nVyFDDZBCJksPNGrpHVTcvQOFQ16Ue6T2hKj3INYMEmelDM9+/7pQf9IAH/bnh4WaM=;
Message-ID: <640965.87593.qm@web15708.mail.cnb.yahoo.com>
X-YMail-OSG: ASePPNAVM1lS2SZYP7F0G5MoFoofpX7TIi0ZdR9quaOy1i4NzzpcLO3ttu9QLVKKdZ6.nDwa7wEPX7FYqyhSv48WdzQpTCKDQWYFvsZK1rckRvd_.cCO4xcl9ny6YhBcrrFyvGV0x.uEzF8_c3PU1Y3311fLfTqKbWgCMz5v_nR.oW4-
X-Mailer: YahooMailClassic/6.0.18 YahooMailWebService/0.7.289.15
Date: Fri, 10 Jul 2009 17:47:16 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Subject: Ask a question about show_code  related mips architecture
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

I met problem under mips  architecture as following .
So I want to know whether <8c820000> is the current fault pointer like i386 ip register ?  Does mips has similar register ? 




epc   : 801343d4     Tainted: P  
ra    : 80134c3c Status: 10008503    KERNEL EXL IE 
Code: 001110c0  00431021  8c440010 <8c820000> 000212c2  30420001

static void show_code(unsigned int __user *pc)
{
	long i;
	unsigned short __user *pc16 = NULL;

	printk("\nCode:");

	if ((unsigned long)pc & 1)
		pc16 = (unsigned short __user *)((unsigned long)pc & ~1);
	for(i = -3 ; i < 6 ; i++) {
		unsigned int insn;
		if (pc16 ? __get_user(insn, pc16 + i) : __get_user(insn, pc + i)) {
			printk(" (Bad address in epc)\n");
			break;
		}
		printk("%c%0*x%c", (i?' ':'<'), pc16 ? 4 : 8, insn, (i?' ':'>'));
	}
}

Thank a lot .
Peter Meng


      
