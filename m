Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbXISORf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbXISORf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbXISOR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:17:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:20065 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbXISOR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:17:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CPFshXOhdkJAOwmEaDHaNXRmBB/JIh4PNAWxLho4mjHMH8+cBO6WRVvN8o6xPkIgTbWnUsXIGLqX+e0yo8Kyj/XQm57roEir3Pl4Ugif2Wgo5bSp/5w4RAXMcP8IAD0xsBiiEpUc8sq09HlxBmvK9GMHmdDs75rPlAJDoygL1+M=
Message-ID: <d120d5000709190717y69dca8b3tf4a17b920267806b@mail.gmail.com>
Date: Wed, 19 Sep 2007 10:17:25 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20070919105054.332308000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070919104125.286538000@chello.nl>
	 <20070919105054.332308000@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Warn when rcu_dereference() is not used in combination with rcu_read_lock()
>

According to Paul it is fine to use RCU primitives (when accompanied
with proper comments) when the read-size critical section is guarded
by spin_lock_irqsave()/spin_lock_irqsrestore() instead of
rcu_read_lock()/rcu_read_unlock() and writers synchronize with
synchronize_sched(), not synchronize_rcu(). Your patch will trigger
warnign on such valid usages.

-- 
Dmitry
