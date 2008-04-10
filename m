Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYDJACP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYDJACP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYDJAB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:01:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbYDJAB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:01:56 -0400
Message-ID: <47FD5899.2040206@zytor.com>
Date: Wed, 09 Apr 2008 17:00:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: Andrew Morton <akpm@osdl.org>, clg@fr.ibm.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] clone64() and unshare64() system calls
References: <20080409222611.GA28087@us.ibm.com>
In-Reply-To: <20080409222611.GA28087@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com wrote:
> This is a resend of the patch set Cedric had sent earlier. I ported
> the patch set to 2.6.25-rc8-mm1 and tested on x86 and x86_64.
> ---
> 
> We have run out of the 32 bits in clone_flags !
> 
> This patchset introduces 2 new system calls which support 64bit clone-flags.
> 
>      long sys_clone64(unsigned long flags_high, unsigned long flags_low,
> 		unsigned long newsp);
> 
>      long sys_unshare64(unsigned long flags_high, unsigned long flags_low);
> 
> The current version of clone64() does not support CLONE_PARENT_SETTID and 
> CLONE_CHILD_CLEARTID because we would exceed the 6 registers limit of some 
> arches. It's possible to get around this limitation but we might not
> need it as we already have clone()
> 

I really dislike this interface.

If you're going to make it a 64-bit pass it in as a 64-bit number, 
instead of breaking it into two numbers.  Better yet, IMO, would be to 
pass a pointer to a structure like:

struct shared {
	unsigned long nwords;
	unsigned long flags[];
};

... which can be expanded indefinitely.

	-hpa
