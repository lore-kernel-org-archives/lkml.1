Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYKQRPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYKQRPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYKQRPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:15:45 -0500
Received: from gw.goop.org ([64.81.55.164]:59250 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYKQRPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:15:44 -0500
Message-ID: <4921A6BE.7000206@goop.org>
Date: Mon, 17 Nov 2008 09:15:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
References: <20081117081117.GD26778@kernel.dk> <20081117082201.GB24603@elte.hu> <20081117083022.GE26778@kernel.dk> <20081117085046.GE28786@elte.hu> <20081117085807.GF26778@kernel.dk> <20081117093425.GG26778@kernel.dk> <20081117094147.GJ28786@elte.hu> <20081117094551.GI26778@kernel.dk> <20081117111350.GJ26778@kernel.dk> <4921A4F3.1030309@goop.org> <20081117171005.GA25729@elte.hu>
In-Reply-To: <20081117171005.GA25729@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Jens Axboe wrote:
>>     
>>> One exception is a real bug that this turned up. The XEN balloon driver
>>> passes the virt address into kunmap() as well, so that part should go in
>>> for 2.6.28. I've CC'ed Jeremy.
>>>   
>>>       
>> Oops.  Acked-by: Jeremy Fitzhardinge  <jeremy.fitzhardinge@citrix.com>
>>     
>
> Could you please send a changelogged fix for x86/urgent, to make sure 
> this shows up in .28?
>   

Subject: xen/balloon: kunmap takes a page *

Pass the struct page * to kunmap, not the vaddr of the mapping itself.

Pointed out by Jens Axboe <jens.axboe@oracle.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -120,7 +120,7 @@
 	if (PageHighMem(page)) {
 		void *v = kmap(page);
 		clear_page(v);
-		kunmap(v);
+		kunmap(page);
 	} else {
 		void *v = page_address(page);
 		clear_page(v);



