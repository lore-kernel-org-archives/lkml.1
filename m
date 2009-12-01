Return-Path: <linux-kernel-owner+w=401wt.eu-S1751004AbZLAFAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004AbZLAFAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 00:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbZLAFAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 00:00:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:42842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZLAFAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 00:00:22 -0500
Message-ID: <4B14A2E6.1070603@kernel.org>
Date: Tue, 01 Dec 2009 14:00:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] percpu: explain quick paths in pcpu_[de]populate_chunk()
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain> <4B13A7ED.9010905@kernel.org> <alpine.DEB.2.00.0911301258370.18682@router.home> <4B145CE9.1060608@kernel.org> <4B147918.3000503@redhat.com>
In-Reply-To: <4B147918.3000503@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/01/2009 11:02 AM, Cong Wang wrote:
> Nope, comments can never fix bad code.
> 
> Since these two break statements are intentional, why not use if?
> Logically, the following two are equalent.
> 
> for(a1; a2; a3){
>     if (a4)
>        return;
>     break;
> }
> 
> 
> a1;
> if (a2) {
>    if (a4)
>        return;
> }
> 
> And the latter is much more readable than the former.

I thought about that but didn't want to open code the special and
fairly complex loop construct used there.  To me, it seemed using the
same loop construct would be much less error-prone than open coding
the loop mostly because those two special cases are the only place
where that is necessary.  Maybe we can add pcpu_first_[un]pop_region()
macros and use them there but is the first iteration check that bad
even with sufficient explanations?

Thanks.

-- 
tejun
