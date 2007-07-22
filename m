Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbXGVIZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbXGVIZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760368AbXGVIYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:24:43 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:55517 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758828AbXGVIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:24:41 -0400
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
In-Reply-To: <385091802.23116@ustc.edu.cn>
References: <20070721210005.000228000@chello.nl>
	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>
	 <385091802.23116@ustc.edu.cn>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 10:24:37 +0200
Message-Id: <1185092677.20032.197.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 16:10 +0800, Fengguang Wu wrote:

> - It will avoid large-file-reads-thrashing-my-desktop problem,
>   so most desktop users should like it. But sure there will be counter
>   cases when a user want to keep the data cached.
> - File servers may hurt from it. Imagine a mp3/png file server. The
>   files are large enough to trigger drop-behind, but small (and hot)
>   enough to be cached. Also when a new fedora DVD iso is released, it
>   may be cached for some days. These are only the obvious cases.
> 
> So I opt for it being made tunable, safe, and turned off by default.

I'm still not convinced (Rik wasn't either last time around). When these
files really are hot, they will be kept in memory due to them becoming
Active.

Also, by scaling up the max readahead size it takes a larger file before
it starts dropping. If say this server has 4G of memory (not much at all
for a server) resulting in a 1M readahead window, the file needs to be >
~2M before it starts drop behind.

But I guess it takes someone to try this IRL before we can settle this
debate :-/

