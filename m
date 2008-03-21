Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbYCUUlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbYCUUlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYCUUln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:41:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:30512 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbYCUUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=iSI2qA+yNjzRkCYK2O2FKmcmTAjz7D+fpel9OOQLPK4Hw9Bz6v50JGlt3m//L01IcPqIXGXNL5XlKL9SW4zY9sjMQfREaKOuSimKovOrKP/KwmdVbyxc0T6EywM5ebHlnQA+sxLcbt9qP5dGjWxnRueL/eMBltrim9ZhnQDGFg0=
Date: Fri, 21 Mar 2008 23:41:06 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: relocate_kernel - use predefined PAGE_SIZE
	instead of own alias
Message-ID: <20080321204106.GB9424@cvg>
References: <20080321201214.GA9424@cvg> <47E41805.5090602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E41805.5090602@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Fri, Mar 21, 2008 at 01:18:13PM -0700]
> Cyrill Gorcunov wrote:
>> This patch does clean up relocate_kernel_(32|64).S a bit by getting rid
>> of local PAGE_ALIGNED macro. We should use well-known PAGE_SIZE instead
>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>
> Looks good!
>
> 	-hpa
>

Thanks Peter for review, btw we have in relocate_kernel_32.S

188:	movl	%cr4, %eax
189:	andl	$0, %eax
190:	movl	%eax, %cr4

but maybe would be better just replace it with

	xorl	%eax, %eax
	movl	%eax, %cr4

or there is some nonobvious reason not to do so?

		- Cyrill -
