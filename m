Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbYBGAxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbYBGAxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934936AbYBGAsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:48:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934433AbYBGAs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:48:26 -0500
Message-ID: <47AA554E.7050405@zytor.com>
Date: Wed, 06 Feb 2008 16:48:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hasan Rashid <hasan@digitalpath.net>
CC: "'Maxim Levitsky'" <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Access MSR functions in userspace?
References: <200802070037.m170b4Bb000579@terminus.zytor.com>
In-Reply-To: <200802070037.m170b4Bb000579@terminus.zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hasan Rashid wrote:
> Maxim, HPA,
> 
>  I loaded the module msr.o and when I try to use wrmsr or rdmsr from the msr
> tools I get rdmsr: open: No such device. It seems like device doesn't
> register upon module load. I have created the devices on the system using
> mknod. Meaning /dev/cpu/msr is there and I changed the appropriate path in
> the msr.c(module) and wrmsr.c (utlity) file. 
> 
> What would prompt this error message?
> 

/dev/cpu/msr is bogus.  It should be /dev/cpu/0/msr etc.

Sounds like your version of udev might be out of date, or you're using 
an old kernel which doesn't communicate /dev/cpu/* to udev properly.

Revert your hacks and, if you have to create the nodes manually, use the 
MAKEDEV script included with the msr-tools.

	-hpa
