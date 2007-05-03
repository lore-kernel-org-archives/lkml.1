Return-Path: <linux-kernel-owner+w=401wt.eu-S1161842AbXECLCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161842AbXECLCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161843AbXECLCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:02:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:17375 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161842AbXECLCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RK3hwBIj6S4qOWnBBzt9XKAWsW4whD/l5OFAyJHsMtoad5n1bOVR9cT+/Ofbo8dbtImQhDKp/5Y35L6lQ0y1f4kDFt+FkUXriJObkv2Zciht0s77IftWyQGl+tRFE40HVfnBsEpskcNfu2Tci6ZNKMJk4cOytx3z6bVi86d7VrU=
Message-ID: <f69849430705030402v5e737de4sc6ab246a1c64ec0e@mail.gmail.com>
Date: Thu, 3 May 2007 04:02:49 -0700
From: "kernel coder" <lhrkernelcoder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: bechmarking kernel code
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
     I'm profiling some part of kernel code.Mine profiling mechanism
is based on rdtsc instruction.

Please tell me if i'm profiling correctly.I'm teting linux kernel
2.6.15 and mine system is P4.


function(){

	unsigned long long c1,c2,c3,c4,c5;
	before=readtsc();
	before=readtsc();
	before=readtsc();
	overhead=readtsc()-before;
	c1=testfunc();
	c2=testfunc();
	c3=testfunc();
	c4=testfunc();
	c5=testfunc();

printk(" \n *c1 = %llu c2= %llu c3 = %llu c4 = %llu c5 = %llu overhead
=%llu",cycles1,cycles2,cycles3,cycles4,cycles5,overhead);


}

/***************************************/


unsigned long long readtsc(){
	unsigned long res[2]={0,0};
      __asm__ __volatile__  (
	      "rdtsc\n"
	       : "=a" (res[0]), "=d" (res[1]) );

	return *((unsigned long long *)res);

}

/*******************************************/

unsigned long long testfunc(){
	unsigned long start_cycles[2]={0,0};
	unsigned long end_cycles[2]={0,0};
	unsigned long long total_cycles=0;
	int i;
      __asm__ __volatile__  (               // read TSC, store edx:eax in res
	      "rdtsc\n"
	       : "=a" (start_cycles[0]), "=d" (start_cycles[1]) );


               /*  CODE TO BE PROFILED */


      __asm__ __volatile__  (               // read TSC, store edx:eax in res
	      "rdtsc\n"
	       : "=a" (end_cycles[0]), "=d" (end_cycles[1]) );
	total_cycles=*((unsigned long long *)end_cycles) - *((unsigned long
long *)start_cycles);
	return total_cycles;
}
