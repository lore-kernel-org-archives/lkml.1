Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZLAB7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZLAB7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 20:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZLAB7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 20:59:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZLAB7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 20:59:35 -0500
Message-ID: <4B147918.3000503@redhat.com>
Date: Tue, 01 Dec 2009 10:02:00 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] percpu: explain quick paths in pcpu_[de]populate_chunk()
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain> <4B13A7ED.9010905@kernel.org> <alpine.DEB.2.00.0911301258370.18682@router.home> <4B145CE9.1060608@kernel.org>
In-Reply-To: <4B145CE9.1060608@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> pcpu_[de]populate_chunk() check whether there's actually any work to
> do at the beginning and exit early if not.  This checking is done by
> seeing whether the first iteration of pcpu_for_each_[un]pop_region()
> covers the whole requested region.  The resulting code is a bit
> unusual in that it's loop-like but never loops which apparently
> confuses people.  Add comments to explain it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Amerigo Wang <amwang@redhat.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> ---
> Added to percpu#for-next.  This should be clear enough, right?
> 

Nope, comments can never fix bad code.

Since these two break statements are intentional, why not use if?
Logically, the following two are equalent.

for(a1; a2; a3){
     if (a4)
        return;
     break;
}


a1;
if (a2) {
    if (a4)
        return;
}


And the latter is much more readable than the former.
