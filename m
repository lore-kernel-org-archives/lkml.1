Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbXIDHTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbXIDHTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 03:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXIDHTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 03:19:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57825 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbXIDHTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 03:19:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=H/uRnzdoGonLOGkf4bfrgc09CeeCSN97HzSYFjGECj+WUGL5cKIbpOjoPn0VLgtTN
	hpFJTrLjmzHggzAP739hA==
Message-ID: <6599ad830709040019r17861771we2a0893c0c160723@mail.gmail.com>
Date: Tue, 4 Sep 2007 00:19:22 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm PATCH] Memory controller improve user interface (v3)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "David Rientjes" <rientjes@google.com>,
       "Dave Hansen" <haveblue@us.ibm.com>
In-Reply-To: <46DC6543.3000607@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070902105021.3737.31251.sendpatchset@balbir-laptop>
	 <6599ad830709022153g1720bcedsb61d7cf7a783bd3f@mail.gmail.com>
	 <46DC6543.3000607@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Paul Menage wrote:
> > On 9/2/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >> -       s += sprintf(s, "%lu\n", *val);
> >> +       if (read_strategy)
> >> +               s += read_strategy(*val, s);
> >> +       else
> >> +               s += sprintf(s, "%lu\n", *val);
> >
> > This would be better as %llu
> >
>
> Hi, Paul,
>
> This does not need fixing, since the other counters like failcnt are
> still unsigned long
>

But val is an unsigned long long*. So printing *val with %lu will
break (at least a warning, and maybe corruption if you had other
parameters) on 32-bit archs.

Paul
