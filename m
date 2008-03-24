Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbYCXRrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbYCXRrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYCXRqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:46:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31959 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbYCXRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:46:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=sWM11SHbQhJuuTQI5uZkQsCKEn6an53pJkXVHw2Cij1uZ41DCPUJsH5Lh0PoN615P
	5hiHLtKjV11WRbgmO+3OQ==
Message-ID: <6599ad830803241046l61e2965t52fd28e165d5df7a@mail.gmail.com>
Date: Mon, 24 Mar 2008 10:46:43 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] Memory controller add mm->owner
Cc: linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47E7E5D0.9020904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324140142.28786.97267.sendpatchset@localhost.localdomain>
	 <6599ad830803240803s5160101bi2bf68b36085f777f@mail.gmail.com>
	 <47E7D51E.4050304@linux.vnet.ibm.com>
	 <6599ad830803240934g2a70d904m1ca5548f8644c906@mail.gmail.com>
	 <47E7E5D0.9020904@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 10:33 AM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>  > OK, so we don't need to handle this for NPTL apps - but for anything
>  > still using LinuxThreads or manually constructed clone() calls that
>  > use CLONE_VM without CLONE_PID, this could still be an issue.
>
>  CLONE_PID?? Do you mean CLONE_THREAD?

Yes, sorry - CLONE_THREAD.

>
>  For the case you mentioned, mm->owner is a moving target and we don't want to
>  spend time finding the successor, that can be expensive when threads start
>  exiting one-by-one quickly and when the number of threads are high. I wonder if
>  there is an efficient way to find mm->owner in that case.
>

But:

- running a high-threadcount LinuxThreads process is by definition
inefficient and expensive (hence the move to NPTL)

- any potential performance hit is only paid at exit time

- in the normal case, any of your children or one of your siblings
will be a suitable alternate owner

- in the worst case, it's not going to be worse than doing a
for_each_thread() loop

so I don't think this would be a major problem

Paul
