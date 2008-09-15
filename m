Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYIOSxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYIOSxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYIOSwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:52:50 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:49518 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYIOSwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:52:50 -0400
Message-ID: <48CEAEF2.1050901@cs.columbia.edu>
Date: Mon, 15 Sep 2008 14:52:34 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [RFC v5][PATCH 2/8] General infrastructure for checkpoint	restart
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>	 <1221347167-9956-3-git-send-email-orenl@cs.columbia.edu> <1221501750.16561.15.camel@nimitz>
In-Reply-To: <1221501750.16561.15.camel@nimitz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Sat, 2008-09-13 at 19:06 -0400, Oren Laadan wrote:
>> +void *cr_hbuf_get(struct cr_ctx *ctx, int n)
>> +{
>> +       void *ptr;
>> +
>> +       BUG_ON(ctx->hpos + n > CR_HBUF_TOTAL);
>> +       ptr = (void *) (((char *) ctx->hbuf) + ctx->hpos);
>> +       ctx->hpos += n;
>> +       return ptr;
>> +}
> 
> All of the casting here is unnecessary.  'void *' behaves like 'char *'
> when you do arithmetic on it.  

ok.

> 
> I really do detest having a memory allocator BUG_ON() when it runs out
> of space.  

The BUG_ON() statement asserts that we don't run out of buffer space.
Buffer usage is a function of the checkpoint/restart logic, and does
not depend on user input, hence not susceptible to DoS.

In other words, if the code is correct, this should never happen (much
like a kernel stack overflow), and if it happens it's a kernel bug. I
think it was Arnd who recommended with regard to this to crash loudly
if there is a bug in the kernel ...

Oren.
