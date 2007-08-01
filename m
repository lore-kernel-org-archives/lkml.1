Return-Path: <linux-kernel-owner+w=401wt.eu-S1765027AbXHANon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765027AbXHANon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762863AbXHANof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:44:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:18966 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbXHANod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i+Pl5YBoPUqvb4LEcH9d/6knKEnAnfk273F1q8LWpj20k7Aw9t2tXAkf+EbWPpvqmLy1R194GADDwy9sQ7K9PP8yUrPtXCfvjPcCRxWiMQMqNpUk4Lis3iz9sWUKG3iSvS9P8mfREB+1dHXvNuijdQnrzNXo71xG+joNyYQ+Na4=
Message-ID: <ed5aea430708010644t5eb961f3nb133354ee5cb071a@mail.gmail.com>
Date: Wed, 1 Aug 2007 07:44:31 -0600
From: "David Mosberger-Tang" <dmosberger@gmail.com>
To: "Zoltan Menyhart" <Zoltan.Menyhart@bull.net>
Subject: Re: [PATCH] flush icache before set_pte take6. [4/4] optimization for cpus other than montecito
Cc: "Luck, Tony" <tony.luck@intel.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <46B0549A.1010308@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <617E1C2C70743745A92448908E030B2A020E3B1C@scsmsx411.amr.corp.intel.com>
	 <46B0549A.1010308@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:

> You do have model specific I cache semantics.
> Not taking it into account will oblige you to flush in vain for the models
> which do not require it. Why do you want to take this option?

Given unlimited resources, your proposal makes perfect sense.  We
could have a Linux version for Merced, one for McKinley, one for
Madison, etc., etc.

(Un)fortunately, resources are limited and with that constraint in
place, rather than spending lots of time optimizing the kernel for
particular idiosyncrasies of a CPU model, it is generally much better
to optimize it for the things the hardware designers promised us would
stay the same across CPU models (i.e., the "architecture").  Sure, it
may mean that on occasion certain things are slightly slower than they
could be but it does have the decided advantage of letting the
maintainers sleep at night... ;-)  Moreover, higher-level
optimizations usually have much higher payoff, so even though you may
do things a bit more slowly at the lowest level, you may end up with a
faster system overall because you were able to spend more time
optimizing at a higher level.

  --david
