Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbXFTLx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbXFTLx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXFTLxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:53:51 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:34508 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753905AbXFTLxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:53:50 -0400
Message-ID: <46791544.704@grupopie.com>
Date: Wed, 20 Jun 2007 12:53:40 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Paulo Marques <pmarques@grupopie.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] remove usage of memmem from scripts/kallsyms.c
References: <4678013C.5090402@grupopie.com> <20070619190454.GB3830@infradead.org>
In-Reply-To: <20070619190454.GB3830@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Jun 19, 2007 at 05:15:56PM +0100, Paulo Marques wrote:
>> The only in-kernel user of "memmem" is scripts/kallsyms.c and it only 
>> uses it to find tokens that are 2 bytes in size. It is trivial to 
>> replace it with a simple function that finds 2-byte tokens.
>>
>> This should help users from systems that don't have the memmem GNU 
>> extension available.
> 
> Please add a comment describing why it's there so that it's not ripped
> out again by the first janitor looking over the code.

I don't see why it would seem a good idea to replace a simple find_token 
  function that searches for 2 byte tokens with a call to memmem. So, I 
think this is not something a janitor would do.

The call to memmem was actually a left-over from a previous algorithm 
that used variable sized tokens. With fixed size, 2 byte tokens, having 
a specialized function is probably more efficient anyway.

-- 
Paulo Marques - www.grupopie.com

"Nostalgia isn't what it used to be."
