Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbXGKEEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbXGKEEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXGKEEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:04:20 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:45282 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXGKEET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:04:19 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Wed, 11 Jul 2007 03:47:09 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Duane Griffin <duaneg@dghda.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Keiichi Kii <k-keiichi@bx.jp.nec.com>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 -mm 8/9] netconsole: Support multiple logging targets
In-Reply-To: <e9e943910707100323o35cb0316i5d3f21584ad8e4ae@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707110340370.2445@cselinux1.cse.iitk.ac.in>
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in>
  <20070710092001.23907.39876.sendpatchset@cselinux1.cse.iitk.ac.in>
 <e9e943910707100323o35cb0316i5d3f21584ad8e4ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 10 Jul 2007, Duane Griffin wrote:
> On 10/07/07, Satyam Sharma <ssatyam@cse.iitk.ac.in> wrote:
> > +       /* Avoid taking lock and disabling interrupts unnecessarily */
> > +       if (unlikely(list_empty(&target_list)))
> > +               return;
> 
> Is the unlikely a good idea here? Not having any targets may be
> unusual but it isn't ridiculous. It might even be a sensible default
> for distros.

Hmm, I put it in there because I expected that the user must have had
at least one target configured (added to target_list) if he's got the
module loaded/built-in (and netconsole registered), which is when this
function would be triggered anyway.

> My (very limited) understanding of unlikely is that it
> could impose a very large penalty in that case and would make a very
> marginal difference at best in the common case.

I wouldn't call it a large penalty, but yeah, probably the unlikely()
there isn't all that important either.

Satyam
