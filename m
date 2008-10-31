Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbYJaO3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbYJaO3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYJaO27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:28:59 -0400
Received: from po-out-1718.google.com ([72.14.252.154]:43165 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbYJaO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:28:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=oiA3OgrnpSgj3kMrOrWnX8N+dNC3irH+EepNr1w9aBkKDZ3Vb/d4DRt3Q9pdYzUUMt
         FyCPMXQuU7Tv7E+L373sudYqkUbJEyUpQ9xeY9s8r2YtS/XwefWKSHx0ujL0jeJVq34x
         EeJSZmv1+PjrcySvau44kPYQV5Bw5LM/8TlWU=
Message-ID: <84144f020810310728j1f3b8a99se428ec55b0c165b5@mail.gmail.com>
Date: Fri, 31 Oct 2008 16:28:57 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Evgeniy Polyakov" <s0mbre@tservice.net.ru>
Subject: SLAB vs. SLUB tbench regression (Was: [tbench regression fixes]: digging out smelly deadmen.)
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>, "David Miller" <davem@davemloft.net>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Matthew Wilcox" <matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: d63d663dcad170a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Fri, Oct 10, 2008 at 1:17 AM, Evgeniy Polyakov
<s0mbre@tservice.net.ru> wrote:
> It was reported recently that tbench has a long history of regressions,
> starting at least from 2.6.23 kernel. I verified that in my test
> environment tbench 'lost' more than 100 MB/s from 470 down to 355
> between at least 2.6.24 and 2.6.27. 2.6.26-2.6.27 performance regression
> in my machines is rougly corresponds to 375 down to 355 MB/s.

As you've already pointed out in private and in your blog, some part
of the tbench regression comes from SLUB vs. SLAB as well. Looks like
I can reproduce the regression locally as well:

  [ 8 clients and tbench_srv on the same machine on 2-way x86-64 ]

                  min      max      avg      sd
  2.6.28-rc2-slab 234.57   244.88   242.68   0.71
  2.6.28-rc2-slub 227.44   240.90   239.08   0.78

Oprofile seems to be busted for 2.6.28-rc2 so I'll follow up on this
as soon as that's settled.

Btw, just as one more data point, I accidentally tested with just 2
clients at first and SLUB actually beat SLAB.

                        Pekka
