Return-Path: <linux-kernel-owner+w=401wt.eu-S1751682AbXCOVJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbXCOVJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXCOVJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:09:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:5811 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbXCOVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TxxG5xedfLLUARzVbB5YV7K7yaK73B6sT7XBJDB+TbV1EW4spR/dMaN81AK4arPYkEnsnXFuSIM0Mv6iQPsFnFcY0FzfM2bjmw7R3u3cD92m6GWD72icg1E+o/zoIclpAj7D3V5qPkKr32vqIRdw02kx6A7xjCsTKcNTWfKPu8I=
Message-ID: <a36005b50703151409x311c2631n1bc10de67b6c6ede@mail.gmail.com>
Date: Thu, 15 Mar 2007 13:09:35 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2/3] FUTEX : introduce private hashtables
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       "pravin b shelar" <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45F9ABD1.70204@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152016.25703.dada1@cosmosbay.com> <45F9ABD1.70204@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> There should be little contention on the memory in the global hash anyway,
> because we can roughly reduce contention as a factor of hash-size/cacheline-size.
>
> What we will have are cache misses on the global table... but we're going to
> get cache misses on those private tables as well.

I'm thinking about NUMA cases.  If you have private tables for a
process which is pinned to some cluster in a NUMA machine the table is
local to the node.  If you have a global table you cannot optimize
your application for such a situation because at least some of the
pages of the global table are remote.
