Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbXGYRXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbXGYRXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761124AbXGYRXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:23:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:21425 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbXGYRXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:23:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,581,1175497200"; 
   d="scan'208";a="272614284"
Date: Wed, 25 Jul 2007 10:23:14 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
In-Reply-To: <20070725120358.GA30755@elte.hu>
Message-ID: <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
 <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Ingo Molnar wrote:

> they now nicely converte to the expected 80% long-term CPU usage.
>
> so, could you please try the patch below, does it work for you too?
>

Thanks for the patch. It doesn't work well on my 8-way box. Here's the 
output at two different times. It's also changing all the time.

[time 1]
  3717 tongli    20   0  7864  108   16 R   85  0.0   1:38.00 loop
  3721 tongli    20   0  7864  108   16 R   85  0.0   1:37.51 loop
  3723 tongli    20   0  7864  108   16 R   84  0.0   1:30.48 loop
  3714 tongli    20   0  7864  108   16 R   83  0.0   1:33.25 loop
  3720 tongli    20   0  7864  108   16 R   81  0.0   1:31.89 loop
  3715 tongli    20   0  7864  108   16 R   78  0.0   1:36.38 loop
  3719 tongli    20   0  7864  108   16 R   78  0.0   1:28.80 loop
  3718 tongli    20   0  7864  108   16 R   78  0.0   1:33.84 loop
  3722 tongli    20   0  7864  108   16 R   76  0.0   1:34.69 loop
  3716 tongli    20   0  7864  108   16 R   70  0.0   1:33.15 loop

[time 2]
  3721 tongli    20   0  7864  108   16 R   91  0.0   1:44.67 loop
  3720 tongli    20   0  7864  108   16 R   89  0.0   1:40.55 loop
  3722 tongli    20   0  7864  108   16 R   86  0.0   1:41.40 loop
  3723 tongli    20   0  7864  108   16 R   82  0.0   1:38.94 loop
  3715 tongli    20   0  7864  108   16 R   82  0.0   1:43.09 loop
  3717 tongli    20   0  7864  108   16 R   79  0.0   1:46.38 loop
  3718 tongli    20   0  7864  108   16 R   79  0.0   1:40.72 loop
  3714 tongli    20   0  7864  108   16 R   77  0.0   1:40.17 loop
  3719 tongli    20   0  7864  108   16 R   73  0.0   1:35.41 loop
  3716 tongli    20   0  7864  108   16 R   61  0.0   1:38.66 loop

I'm running 2.6.23-rc1 with your patch on a two-socket quad-core system. 
Top refresh rate is the default 3s.

   tong
