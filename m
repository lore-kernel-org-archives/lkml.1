Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbZLAFrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbZLAFrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 00:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZLAFrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 00:47:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:43251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZLAFrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 00:47:11 -0500
Message-ID: <4B14ADE0.3020007@kernel.org>
Date: Tue, 01 Dec 2009 14:47:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] percpu: explain quick paths in pcpu_[de]populate_chunk()
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain> <4B13A7ED.9010905@kernel.org> <alpine.DEB.2.00.0911301258370.18682@router.home> <4B145CE9.1060608@kernel.org> <4B147918.3000503@redhat.com> <4B14A2E6.1070603@kernel.org> <4B14A51E.2090702@kernel.org> <4B14AC35.3020700@redhat.com>
In-Reply-To: <4B14AC35.3020700@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/01/2009 02:40 PM, Cong Wang wrote:
>> So, I don't know.  The first iteration only loop looks a bit unusual
>> for sure but it isn't something conceptually convoluted.
> 
> Now this seems to be better. So with this change, we can do:
> 
> pcpu_first_pop_region(chunk, rs, re, start, end);
> if (rs < re && ...)
>    return;
> 
> Right?

Yeap, but is that any better?  Passing lvalue loop parameters to loop
constructs is customary.  For almost all other cases, it's not, so

 pcpu_first_pop_region(chunk, &rs, &re, start, end)

would be better but then we have two similar looking interfaces which
take different types of parameters.  Also, you probably can drop rs <
re test there but for me it just seems easier to simply check the
first iteration.  If you think it's something worth changing and it
looks better afterwards, please send a patch.

Thanks.

-- 
tejun
