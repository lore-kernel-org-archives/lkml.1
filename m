Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYBHMvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYBHMvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYBHMu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:50:58 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:51438 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYBHMu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:50:57 -0500
Message-ID: <47AC502C.70809@linux.vnet.ibm.com>
Date: Fri, 08 Feb 2008 18:20:52 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: rusty@rustcorp.com.au, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [BUILD_FAILURE] 2.6.24-git18 build fails section type conflict
 psmouse-base
References: <47AC2FDB.7080104@linux.vnet.ibm.com> <20080208104851.GI7198@cs181133002.pp.htv.fi>
In-Reply-To: <20080208104851.GI7198@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Feb 08, 2008 at 04:02:59PM +0530, Kamalesh Babulal wrote:
>> Hi,
>>
>> The 2.6.24-git18 kernel build fails on the power machine with following message
>>
>> drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
>> drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
>> make[3]: *** [drivers/input/mouse/psmouse-base.o] Error 1
>> make[2]: *** [drivers/input/mouse] Error 2
>> make[1]: *** [drivers/input] Error 2
>> make: *** [drivers] Error 2
>>
>> this failure was reported earlier http://lkml.org/lkml/2007/9/22/64
> 
> You need the patch from [1] manually applied (due to changed context) 
> and with " || defined(__powerpc__)" added for getting it compiling.
> 
> @Rusty:
> Can you look at this issue? It's a modules problem on 3 architectures.
> 
> cu
> Adrian
> 
> [1] http://lkml.org/lkml/2007/12/27/29
> 
I tried manually applying the patch and added ||defined(__powerpc__), the above
build failure was resolved but it started failing at another place, 

  CC      kernel/printk.o
kernel/printk.c:568: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘static’
make[1]: *** [kernel/printk.o] Error 1
make: *** [kernel] Error 2


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
