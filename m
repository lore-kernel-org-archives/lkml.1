Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYFSJqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYFSJqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYFSJqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:46:11 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:17876 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbYFSJqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:46:11 -0400
Message-Id: <485A4715.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 19 Jun 2008 10:46:29 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Dave Airlie" <airlied@gmail.com>
Cc: "Dave Airlie" <airlied@linux.ie>, <linux-kernel@vger.kernel.org>
Subject: Re: agp: two-stage page destruction issue
References: <4858E330.76E4.0078.0@novell.com>
 <21d7e9970806181657l79fa4e43oc42f23a18a33c4ee@mail.gmail.com>
In-Reply-To: <21d7e9970806181657l79fa4e43oc42f23a18a33c4ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Dave Airlie" <airlied@gmail.com> 19.06.08 01:57 >>>
>On Wed, Jun 18, 2008 at 6:28 PM, Jan Beulich <jbeulich@novell.com> wrote:
>> Dave,
>>
>> besides it apparently being useful only in 2.6.24 (the changes in 2.6.25
>> really mean that it could be converted back to a single-stage mechanism),
>> I'm seeing an issue in Xen Dom0 kernels, which is caused by the calling
>> of gart_to_virt() in the second stage invocations of the destroy function.
>> I think that besides this being a real issue with Xen (where
>> unmap_page_from_agp() is not just a page table attribute change), this
>> also is invalid from a theoretical perspective: One should not assume that
>> gart_to_virt() is still valid after unmapping a page. So minimally (keeping
>> the 2-stage mechanism) a patch like the one below would be needed.
>>
>
>Looks good to me, its the simpler change for 2.6.26 at this point.
>
>Dave.

So if you're considering it even for 2.6.26, will you push it to Linus? That's
how I understand the process would generally work, or should I push it
in this case (in which case it might be good to know whether your above
statement should be translated into an Acked-by or Signed-off-by)?

Thanks, Jan

