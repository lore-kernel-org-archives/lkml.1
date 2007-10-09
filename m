Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbXJITYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbXJITYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXJITXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:23:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35680 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbXJITXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:23:53 -0400
Message-ID: <470BD539.9020703@zytor.com>
Date: Tue, 09 Oct 2007 12:23:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v4 0/3] i386/x86_64 boot: 32-bit boot protocol
References: <1191912003.9719.17.camel@caritas-dev.intel.com>
In-Reply-To: <1191912003.9719.17.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> - Which fields of boot parameters should be exported directly in
>   sysfs? Export all fields of boot parameters in sysfs is too complex
>   and unnecessary. Which fields should be?
> 

The main this is that since this is a fixed-format, ABI-defined 
structure, regardless of individual fields it should be exported as a 
binary object.  That is also the only way to deal with a kernel which 
may not itself know about specific items making the data available to 
other users, like kexec.

It's not clear to me from reading the code what model you're using for 
exporting this data in sysfs.  Could you describe it in some detail?

What I had envisioned would be an object for the boot_params structure 
and a systematic object for each linked-list object, at a very minimum.

	-hpa
