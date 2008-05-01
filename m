Return-Path: <linux-kernel-owner+w=401wt.eu-S934631AbYEAADz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934631AbYEAADz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761803AbYEAABR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:01:17 -0400
Received: from mga05.intel.com ([192.55.52.89]:38988 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934442AbYEAABQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:01:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,731,1199692800"; 
   d="scan'208";a="559150044"
Message-ID: <48190844.5080804@linux.intel.com>
Date: Wed, 30 Apr 2008 17:01:08 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: WARNING: at kernel/panic.c:375 __stack_chk_test+0x50/0x54()
References: <4819078C.9080405@gmail.com>
In-Reply-To: <4819078C.9080405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> 
> Hi Arjan,
> 
> There doesn't seem to be an entry in MAINTAINERS for stack protector, 
> but your signoff was on the last stack protector related commit I could 
> find, so it's probably a good bet.
> 
> I get the following in my dmesg after testing linux-next with the stack 
> protector turned on.  This is an x86-64 UP box if that helps.  It 
> appears to be related to the test for the feature (or perhaps that is 
> supposed to happen when the feature is tested, I'm not sure...).  Config 
> below.
> 

the important question is: exactly what gcc are you using? (and if you use a distro gcc,
which distro)

second question would be, what does the following command give?

echo "int foo(void) { char X[200]; return 3; }" | $1 -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o -

(this is the command from scripts/gcc-x86_64-has-stack-protector.sh that the kernel uses to test at compiletime
  if you have stack protector support)
