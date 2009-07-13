Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZGMJQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZGMJQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZGMJQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:16:20 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:46059 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbZGMJQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:16:20 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: tom.leiming@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 11:16:14 +0200
Message-Id: <1247476574.7529.55.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 23:04 +0800, tom.leiming@gmail.com wrote:
> Hi,Peter
> 
> Currently lockdep uses recursion DFS(depth-first search) algorithm to
> search target in checking lock circle(check_noncircular()),irq-safe
> -> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
> lock dependency. This patches replace the current DFS with BFS, based on
> the following consideration:
> 
>     1,no loss of efficiency, no matter DFS or BFS, the running time
>     are O(V+E) (V is vertex count, and E is edge count of one
>     graph);

I'd still like to get some feedback on the loss of that generation count
optimization done by DaveM, I haven't had time to analyze the
ramifications of that.

