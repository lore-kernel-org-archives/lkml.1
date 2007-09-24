Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbXIXKYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbXIXKYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbXIXKY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:24:29 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:12560 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbXIXKY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:24:27 -0400
Date: Mon, 24 Sep 2007 12:24:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070924122422.75562c41@twins>
In-Reply-To: <1190628609.6389.14.camel@Homer.simpson.net>
References: <1190144190.5204.24.camel@earth>
	<20070918201622.GA1632@elte.hu>
	<Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	<1190183324.9737.7.camel@Homer.simpson.net>
	<1190188261.9185.21.camel@Homer.simpson.net>
	<1190191368.8687.5.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	<1190264114.6411.4.camel@Homer.simpson.net>
	<1190272507.27867.20.camel@Homer.simpson.net>
	<20070920075155.GA31641@elte.hu>
	<1190275870.9232.6.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
	<1190455308.7404.19.camel@Homer.simpson.net>
	<1190531662.11524.15.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0709232259150.23861@tongli.jf.intel.com>
	<1190628609.6389.14.camel@Homer.simpson.net>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 12:10:09 +0200 Mike Galbraith <efault@gmx.de> wrote:


> @@ -117,7 +117,7 @@ static inline struct task_struct *task_o
>  static inline u64
>  max_vruntime(u64 min_vruntime, u64 vruntime)
>  {
> -	if ((vruntime > min_vruntime) ||
> +	if (((s64)vruntime > (s64)min_vruntime) ||
>  	    (min_vruntime > (1ULL << 61) && vruntime < (1ULL << 50)))
>  		min_vruntime = vruntime;
>  

how about something like:

 s64 delta = (s64)(vruntime - min_vruntime);
 if (delta > 0)
  min_vruntime += delta;

That would rid us of most of the funny conditionals there.
