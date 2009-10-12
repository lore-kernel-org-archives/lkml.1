Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZJLIC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZJLIC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZJLIC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:02:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:37837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbZJLICX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:02:23 -0400
Message-ID: <4AD2E258.9090706@kernel.org>
Date: Mon, 12 Oct 2009 17:01:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32-rc3] fix pcpu_embed_first_chunk() compile warnings
References: <19151.3066.304514.621378@pilspetsen.it.uu.se>
In-Reply-To: <19151.3066.304514.621378@pilspetsen.it.uu.se>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 08:01:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Compiling 2.6.32-rc3 on i686 I get the following new warnings:
> 
> mm/percpu.c: In function 'pcpu_embed_first_chunk':
> mm/percpu.c:1873: warning: comparison of distinct pointer types lacks a cast
> mm/percpu.c:1879: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'size_t'
> 
> They are caused by 6ea529a2037ce662fc6bfa572b46d47407d08805
> "make embedding first chunk allocator check vmalloc space size".
> 
> The first warning is because max() is applied to one operand of
> type 'size_t' and another of type 'unsigned long'. Fix: cast the
> second one to 'size_t'.
> 
> For the second warning: always use '%z' to format 'size_t' operands.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

For some reason, I've been thinking this was linux-next specific and
committed about the same patch there, commit 3cbeae2f, a while ago.
The only difference was use of max_t() instead of size_t cast.  I
think max_t() is cleaner there and will cherry pick the patch from
linux-next.

Thanks.

-- 
tejun
