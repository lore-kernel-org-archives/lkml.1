Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbYCUUxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbYCUUxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbYCUUxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:53:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:11036 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYCUUxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BL9GXPTuf8rzYW8yFK0MJvmfx1FgfdjRiklU5Z/l6E8/i9v8Ceg7V4ExbEA+tzAf5E16Y+CxuaIo7tyRDXEnQdtu1vPQjirKBz/cBHa0fNbJ3oKmFPmYsx4OHQnkgsOaTYu+n+GXiMR7vrdwRcZMU4SKfQdYWoHh5EZweseFaNs=
Date: Fri, 21 Mar 2008 23:52:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: relocate_kernel - use predefined PAGE_SIZE
	instead of own alias
Message-ID: <20080321205248.GC9424@cvg>
References: <20080321201214.GA9424@cvg> <47E41805.5090602@zytor.com> <20080321204106.GB9424@cvg> <47E41F99.7090904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E41F99.7090904@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Fri, Mar 21, 2008 at 01:50:33PM -0700]
> Cyrill Gorcunov wrote:
>> [H. Peter Anvin - Fri, Mar 21, 2008 at 01:18:13PM -0700]
>>> Cyrill Gorcunov wrote:
>>>> This patch does clean up relocate_kernel_(32|64).S a bit by getting rid
>>>> of local PAGE_ALIGNED macro. We should use well-known PAGE_SIZE instead
>>>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>>> Looks good!
>>>
>>> 	-hpa
>>>
>> Thanks Peter for review, btw we have in relocate_kernel_32.S
>> 188:	movl	%cr4, %eax
>> 189:	andl	$0, %eax
>> 190:	movl	%eax, %cr4
>> but maybe would be better just replace it with
>> 	xorl	%eax, %eax
>> 	movl	%eax, %cr4
>> or there is some nonobvious reason not to do so?
>
> The only case I can think of would be if the code expects to patch the 
> zero, but even then it'd be cantankerous, because gas will optimize that 
> zero down to a single byte.
>
> So, no :)
>
> 	-hpa
>
>

ah! thanks ;)

		- Cyrill -
