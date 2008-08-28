Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYH1U6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYH1U6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbYH1U6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:58:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49452 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbYH1U57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:57:59 -0400
Message-ID: <48B71093.3070409@cs.helsinki.fi>
Date: Thu, 28 Aug 2008 23:54:43 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bitfields API
References: <20080828183223.GA30781@localhost.localdomain> <20080828184025.GA22165@x200.localdomain> <48B6F12F.1010909@cs.helsinki.fi> <20080828202750.GB16462@cs181140183.pp.htv.fi>
In-Reply-To: <20080828202750.GB16462@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>> Heh, heh, one alternative is to have a kmemcheck_memset() thingy that  
>> unconditionally zeroes bit fields and maybe is a no-op when kmemcheck is  
>> disabled.
> 
> This sounds as if this might cause bugs to disappear when debugging gets 
> turned on?

Yeah, I suppose. The problem doing that unconditionally is that it 
increases kernel text slightly on some architectures (e.g. sparc). 
However, as long as you use the KMEMCHECK_BIT_FIELD annotation only in 
places that give you false positives, it's we should be safe.

		Pekka
