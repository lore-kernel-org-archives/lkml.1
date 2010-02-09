Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0BIQtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:49:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab0BIQtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:49:07 -0500
Message-ID: <4B7191D4.4000101@redhat.com>
Date: Tue, 09 Feb 2010 11:48:20 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH]  fs: buffer_head, remove kmem_cache constructor to reduce
 memory usage under slub
References: <1265722191.4033.36.camel@localhost>
In-Reply-To: <1265722191.4033.36.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 08:29 AM, Richard Kennedy wrote:
> fs: Remove the buffer_head kmem_cache constructor to reduce memory usage
> under slub.
>
> When using slub, having a kmem_cache constructor forces slub to add a
> free pointer to the size of the cached object, which can have a
> significant impact to the number of small objects that can fit into a
> slab.
>
> As buffer_head is relatively small and we can have large numbers of
> them, removing the constructor is a definite win.
>
> On x86_64 removing the constructor gives me 39 objects/slab, 3 more than
> without the patch. And on x86_32 73 objects/slab, which is 9 more.
>
> As alloc_buffer_head() already initializes each new object there is very
> little difference in actual code run.
>
> Signed-off-by: Richard Kennedy<richard@rsk.demon.co.uk>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
