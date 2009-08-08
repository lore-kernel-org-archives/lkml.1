Return-Path: <linux-kernel-owner+w=401wt.eu-S933596AbZHHHfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbZHHHfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 03:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933385AbZHHHfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 03:35:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49136 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292AbZHHHfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 03:35:37 -0400
Date: Sat, 8 Aug 2009 09:35:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2
Message-ID: <20090808073534.GA12190@basil.fritz.box>
References: <20090806180930.GA3004@localdomain.by> <87d478i0d7.fsf@basil.nowhere.org> <4A7CEC70.4050806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7CEC70.4050806@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 09:09:36PM -0600, Robert Hancock wrote:
> On 08/07/2009 12:50 AM, Andi Kleen wrote:
>> Sergey Senozhatsky<sergey.senozhatsky@gmail.com>  writes:
>>> Of course, compiler supposed to do something like
>>> 	add    $0x7,%eax
>>> 	shr    $0x3,%eax
>>> instead of div. Should we rely on this?
>>
>> Yes. We should rely on this.
>
> It may depend on the selected CPU type that gcc is optimizing for - I 
> believe that on some P4s the shift may actually be slower than the divide..

DIV should be always slower than a SHIFT.

But it has nothing really to do with the CPU. The point is that the compiler
always selects a suitable one by itself. Rewriting x / 2 to x >> 1 is
one of the easiest exercises in compiler optimizations.

The only case when the compiler cannot do this easily by itself is 
when the dividend is not a constant.

That said -Os sometimes screws us up on this, but it's still not worth
doing this change manually.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
