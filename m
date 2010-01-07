Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765Ab0AGTUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0AGTUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745Ab0AGTUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:20:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab0AGTUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:20:04 -0500
Message-ID: <4B4633D3.2070903@zytor.com>
Date: Thu, 07 Jan 2010 11:19:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, brgerst@gmail.com
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 04:43 AM, Christian Kujau wrote:
> 
> I've run a few more bisections and this is where I have arrived now:
> 
> http://nerdbynature.de/bits/2.6.33-rc2/xen/bisect/git-bisect_finished.log
> 
> ...with the last iteration being:
> 
> 
> # git bisect good
> 3bd95dfb182969dc6d2a317c150e0df7107608d3 is the first bad commit
> commit 3bd95dfb182969dc6d2a317c150e0df7107608d3
> Author: Brian Gerst <brgerst@gmail.com>
> Date:   Wed Dec 9 12:34:40 2009 -0500
> 
>     x86, 64-bit: Move kernel_thread to C
>     
>     Prepare for merging with 32-bit.
>     
>     Signed-off-by: Brian Gerst <brgerst@gmail.com>
>     LKML-Reference: <1260380084-3707-2-git-send-email-brgerst@gmail.com>
>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> 
> :040000 040000 30b5dd4d6888694ca2967893ef3e662461fe9978 
> 0bb5fb33914aac10aaf0344fb8cff596378be52a M      arch
> 
> 
> @Brian, hpa: I've Cc'ed you on this one, here's what I'm whining about:
>              http://lkml.org/lkml/2010/1/5/489
> 
> 
> Please let me know if this makes sense or if the bisection looks 
> funny/invalid.
> 

The big difference between the code before and after this commit is that
before, kernel_thread() would initialize the pt_regs structure with
whatever state happened to be passed into it by the caller, whereas
afterwards it is initialized to zero.  It's unclear to me why that would
break Xen, but therein lies the problem with paravirtualization... it's
not actually running the same thing the real architecture.
	
	-hpa

