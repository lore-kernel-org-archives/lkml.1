Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZGUWeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZGUWeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbZGUWeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:34:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbZGUWeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:34:05 -0400
Date: Tue, 21 Jul 2009 15:33:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: containers@lists.linux-foundation.org, bblum@google.com,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC][PATCH] flexible array implementation
Message-Id: <20090721153356.f62d8424.akpm@linux-foundation.org>
In-Reply-To: <1248213411.13249.5669.camel@nimitz>
References: <20090721160333.96AA4D3D@kernel>
	<20090721131839.27f3a5aa.akpm@linux-foundation.org>
	<1248213411.13249.5669.camel@nimitz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 14:56:51 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> I've added some comments in the kerneldoc for the (newly renamed) alloc
> function:
> 
>  * The maximum number of elements is currently the number of elements
>  * that can be stored in a page times the number of page pointers
>  * that we can fit in the base structure or (using integer math):
>  *
>  *      (PAGE_SIZE/element_size) * (PAGE_SIZE-8)/sizeof(void *)
>  *
>  * Here's a table showing example capacities.  Note that the maximum
>  * index that the get/put() functions is just nr_objects-1.
>  *
>  * Element size | Objects  | Objects |
>  * PAGE_SIZE=4k |  32-bit  |  64-bit |
>  * ----------------------------------|
>  *      1 byte  |  4186112 | 2093056 |
>  *      2 bytes |  2093056 | 1046528 |
>  *      3 bytes |  1395030 |  697515 |
>  *      4 bytes |  1046528 |  523264 |
>  *     32 bytes |   130816 |   65408 |
>  *     33 bytes |   126728 |   63364 |
>  *   2048 bytes |     2044 |   10228 |
>  *   2049 bytes |     1022 |     511 |
>  *       void * |  1046528 |  261632 |

4-bytes on 32-bit and 8-bytes on 64-bit are the most interesting ones
(IMO).  So what we're basically saying is "2MB on 64-bit".

I wonder if that's enough for known likely callers.  Hopefully it is.

