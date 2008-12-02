Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYLBMDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYLBMDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 07:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYLBMD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 07:03:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:62786 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYLBMD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 07:03:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AvBkU7EZ/u8J5lHgKfEeNs3Pqvc1S/g0j/4AFocbcnzgS6mlAMF/KHnx0kneF0raMd
         HswsWooOc8X0HkNIalvRYSI4fMNFGQcqq09meWjpih8xjP0Vx+TLitQMhgYOKTb7yhIq
         2nFhiK82aduXDUx+zQrvUO3Kiysw9yw1FUoUk=
Message-ID: <c62985530812020403ve8fff04w17c0b5a3e88dab19@mail.gmail.com>
Date: Tue, 2 Dec 2008 13:03:26 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-graph-tracer: support for x86-64
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
In-Reply-To: <20081202090556.GA12479@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49347147.8070405@gmail.com> <20081202090205.GA11632@elte.hu>
	 <20081202090556.GA12479@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/2 Ingo Molnar <mingo@elte.hu>:
> Graph tracer output from a 64-bit testbox:
>
>  0)               |                cache_grow() {
>  0)      0.323 us |                  _spin_lock();
>  0)      0.314 us |                  kmem_flagcheck();
>  0)               |                  kmem_getpages() {
>  0)               |                    __alloc_pages_internal() {
>  0)               |                      get_page_from_freelist() {
>  0)      0.295 us |                        next_zones_zonelist();
>  0)      0.306 us |                        next_zones_zonelist();
>  0)      0.394 us |                        zone_watermark_ok();
>  0)      0.415 us |                        _spin_lock_irqsave();
>  0)               |                        __rmqueue() {
>  0)               |                          __rmqueue_smallest() {
>  0)      0.387 us |                            __mod_zone_page_state();
>  0)      1.514 us |                          }
>  0)      2.369 us |                        }
>  0)               |                        zone_statistics() {
>  0)      0.297 us |                          __inc_zone_state();
>  0)      0.290 us |                          __inc_zone_state();
>  0)      1.448 us |                        }
>  0)      7.315 us |                      }
>  0)      7.967 us |                    }
>  0)               |                    mod_zone_page_state() {
>  0)      0.285 us |                      __mod_zone_page_state();
>  0)      0.931 us |                    }
>  0)      9.993 us |                  }
>  0)               |                  kmem_cache_alloc_node() {
>  0)               |                    cache_alloc_refill() {
>
> nice :)
>
>        Ingo
>

:-)

Yesterday, I noticed some rare and weird things like this:

leaf_func();
leaf_func();
leaf_func();
leaf_func() {
leaf_func();
leaf_func();

I'm not sure of the origin. I will investigate....
