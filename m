Return-Path: <linux-kernel-owner+w=401wt.eu-S1161039AbXCGAj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbXCGAj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161043AbXCGAj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:39:26 -0500
Received: from terminus.zytor.com ([192.83.249.54]:49107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161039AbXCGAjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:39:25 -0500
Message-ID: <45EE09B4.40207@zytor.com>
Date: Tue, 06 Mar 2007 16:39:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Chen, Dongliang" <Chen.D@ems-t.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: return negative number for unsigned long function in kernel
References: <314BE1148B8C8D468A05944FDF577583069B021E@MRE02.enterprise.com>
In-Reply-To: <314BE1148B8C8D468A05944FDF577583069B021E@MRE02.enterprise.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chen, Dongliang wrote:
> There are lots of functions in the Linux kernel that are declared as
> unsigned long, but the return value is negative integer while error
> occurred. An example of these functions is do_mmap_pgoff in mm/mmap.c,
> which is defined as:
> 
> unsigned long do_mmap_pgoff(....)
> 
> In this function, it returns -ENODEV, -EPERM, -ENOMEM, -EINVAL, -EAGAIN,
> -EACCESS depends on the error type. My question is how should the caller
> perform error check based on the return value? 
> 

If you want to test for errorness, you could use the macro 
IS_ERR_VALUE().  Unfortunately the macro isn't all that safe, in that it 
will give you the wrong answer if it's ever used on something that 
*isn't* an unsigned long.

	-hpa

