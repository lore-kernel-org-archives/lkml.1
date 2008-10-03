Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbYJCOQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbYJCOQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbYJCOQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:16:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYJCOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:16:38 -0400
Message-ID: <48E62906.3030506@linux-foundation.org>
Date: Fri, 03 Oct 2008 09:15:34 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rusty@rustcorp.com.au, jeremy@goop.org,
       ebiederm@xmission.com, travis@sgi.com, herbert@gondor.apana.org.au,
       xemul@openvz.org
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080929193500.470295078@quilx.com>	<20080929193516.278278446@quilx.com>	<20081003003342.4d592c1f.akpm@linux-foundation.org>	<1223019811.30285.12.camel@penberg-laptop> <20081003012003.f1f84937.akpm@linux-foundation.org>
In-Reply-To: <20081003012003.f1f84937.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>
> umm, yeah, the whole bitmap interface is busted from that POV.


Yup cannot find equivalent bitmap operations for cpu_alloc.

Also the search operations already use find_next_zero_bit() and
find_next_bit(). So this should be okay.

We could define new bitops:

bitmap_set_range(dst, start, end)
bitmap_clear_range(dst, start, end)

int find_zero_bits(dst, start, end, nr_of_zero_bits)

but then there are additional alignment requirements that such a generic
function would not be able to check for.


