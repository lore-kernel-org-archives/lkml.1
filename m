Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbYJXU2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbYJXU2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYJXU2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:28:11 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:36955 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYJXU2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:28:10 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 7/8] sched: non-zero lag renice
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, efault@gmx.de,
       vatsa@in.ibm.com
In-Reply-To: <49020A2A.5070809@nortel.com>
References: <20081024090611.936552213@chello.nl>
	 <20081024091109.912152294@chello.nl>  <49020A2A.5070809@nortel.com>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 22:28:03 +0200
Message-Id: <1224880083.7753.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 11:47 -0600, Chris Friesen wrote:
> Peter Zijlstra wrote:
> 
>  > Then renicing, esp when lowering nice value (getting heavier), its possible
>  > to get into a starvation scenario. If you got too much runtime as a very
>  > light task, you get shot way far too the right, which means you'll have to
>  > wait for a long time in order to run again.
>  >
>  > If during that wait you get reniced down, fairness would suggest you get run
>  > earlier, because you deserve more time.
>  >
>  > This can be solved by scaling the vruntime so that we keep the real-time
>  > lag invariant.
> 
> If we've already been shot way out to the right, presumably that would give us 
> a large real-time lag.  If we renice to a lower nice level, wouldn't we want 
> to reduce the real-time lag rather than make it constant?

Ah, see but a 1ms real-time lag might be gigantic on weight=15, but
nearly nothing on weight=88761.

1e6 * 1024/15 is massively larger than 1e6 * 1024/88761.

1000000*1024/15 = 68266666
1000000*1024/88761 = 11536




