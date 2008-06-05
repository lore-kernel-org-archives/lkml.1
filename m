Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYFERC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYFERC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYFERCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:02:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYFERCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:02:19 -0400
Message-ID: <48481846.6060407@kernel.org>
Date: Thu, 05 Jun 2008 09:45:58 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Stable Kernel <stable@kernel.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
References: <4848046A.5060006@goop.org> <484823BD.76E4.0078.0@novell.com> <4848096D.9010603@goop.org>
In-Reply-To: <4848096D.9010603@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> We could have an auction:
> 
>    Do I hear 46? 47? 48?  50?  52!  Going once, twice, 52 bits!
> 
> Anyway, we can fix it later in a separate patch.  This is a 
> change-as-little-as-possible bugfix patch.
> 

It should either be 52 bits or dynamic based on CPUID information.  The 
latter is very expensive.

If there end up being additional control bits assigned in this space we 
won't use them  since we know the size of the address space (which won't 
include the control bits) and thus will leave them at zero.

It's largely theoretical, since I believe Linux on x86-64 relies on 
virtual >= physical+N, where I believe N is about 3 bits, and the page 
table format or page size need to change to support more than 48 bits of 
virtual address space.

	-hpa
