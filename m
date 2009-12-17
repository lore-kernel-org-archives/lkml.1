Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbZLQO4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbZLQO4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZLQO4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:56:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50136 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZLQO4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:56:37 -0500
Message-ID: <4B2A4667.6060500@zytor.com>
Date: Thu, 17 Dec 2009 06:55:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, x86@kernel.org
Subject: Re: 2.6.32: x86_32: Destination address is too large.
References: <a4423d670912170536m64e71c81v65b11fded21907fb@mail.gmail.com>
In-Reply-To: <a4423d670912170536m64e71c81v65b11fded21907fb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 05:36 AM, Alexander Beregalov wrote:
> 
> #ifdef CONFIG_X86_64
>         if (heap > 0x3fffffffffffUL)
>                 error("Destination address too large");
> #else
>         if (heap > ((-__PAGE_OFFSET-(512<<20)-1) & 0x7fffffff))
>                 error("Destination address too large");
> #endif
> 
> 
> heap is 0x31341b80 here,
> CONFIG_PAGE_OFFSET=0xC0000000
> 

Nevermind, the equation turns out to be 0x1fffffff, and thus it is an
error... exactly how are you loading the kernel?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

