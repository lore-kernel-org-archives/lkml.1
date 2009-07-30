Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZG3BMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZG3BMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 21:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZG3BMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 21:12:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32168 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbZG3BMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 21:12:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=BPXAsbKqamL6eySyO43ImugzuDH/Qva+8j6v1l1OZRH1t8ywH1qwKkT1eQTfwvmwa
	ntu2IGjvpFbP51IzUgHBw==
MIME-Version: 1.0
In-Reply-To: <20090730010630.GA7326@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com>
	 <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com>
	 <20090729114322.GA9335@localhost>
	 <33307c790907290711s320607b0i79c939104d4c2d61@mail.gmail.com>
	 <20090730010630.GA7326@localhost>
Date: Wed, 29 Jul 2009 18:12:26 -0700
Message-ID: <33307c790907291812j40146a96tc2e9c5e097a33615@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree on the unification of kupdate and sync paths. In fact I had a
> patch for doing this. And I'd recommend to do it in two patches:
> one to fix the congestion case, another to do the code unification.
>
> The sync path don't care whether requeue_io() or redirty_tail() is
> used, because they disregard the time stamps totally - only order of
> inodes matters (ie. starvation), which is same for requeue_io()/redirty_tail().

But, as I understand it, both paths share the same lists, so we still have
to be consistent?

Also, you set flags like more_io higher up in sync_sb_inodes() based on
whether there's anything in s_more_io queue, so it still seems to have
some effect to me?
