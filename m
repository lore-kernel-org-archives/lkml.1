Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbYLLCIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbYLLCIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 21:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbYLLCId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 21:08:33 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:32750 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756953AbYLLCIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 21:08:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0Hko8H8lh1AytvRMOu7ZsgMRh88xAOLNTv+D1+iS3HA66cPARrtFOtXHCm4IMv7MbsBQdj5F5/1Nctu30290IgWXHqJQr+PGsWjZTdVAVt6MhbyJB5ujUEhsHFZtdA7jl6j77kLVCsEzw+WKFzPeOPbTyelHP89p1YPpGxfGY0M=  ;
X-YMail-OSG: o1ikndYVM1kWNR5IwScgonUTk62jrppJQBzKlC_oKMLZx6G6mlVtcs8x4Xftdj6hnE8kyZdsJo9_.OzavQJCsTkMP6XTYG24HzjfHzUqU2efyauyh90iND0NhqXR1BmwSdlI7VSN4z3ad12suOPUKdFbf_VMaBK7b3tj1IL51aeO1.pTa6lQB9ElWrAn
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH v3 2/7] fs: Use a percpu_counter to track nr_inodes
Date: Tue, 24 Jul 2007 11:30:55 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <493100B0.6090104@cosmosbay.com> <4941968E.3020201@cosmosbay.com>
In-Reply-To: <4941968E.3020201@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241130.56767.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 09:39, Eric Dumazet wrote:
> Avoids cache line ping pongs between cpus and prepare next patch,
> because updates of nr_inodes dont need inode_lock anymore.
>
> (socket8 bench result : no difference at this point)

Looks good.

But.... If we never actually need fast access to the approximate
total, (which seems to apply to this and the previous patch) we
could use something much simpler which does not have the spinlock
or all this batching stuff that percpu counters have. I'd prefer
that because it will be faster in a straight line...

(BTW. percpu counters can't be used in interrupt context? That's
nice.)

