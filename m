Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbZI1NYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbZI1NYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZI1NYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:24:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:36651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZI1NYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:24:04 -0400
Subject: Re: [patch 03/33] fs: scale files_lock
From: Peter Zijlstra <peterz@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090904065534.303326352@nick.local0.net>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065534.303326352@nick.local0.net>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 15:24:08 +0200
Message-Id: <1254144248.15795.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 16:51 +1000, npiggin@suse.de wrote:
> Improve scalability of files_lock by adding per-cpu, per-sb files lists,
> protected with per-cpu locking. Effectively turning it into a big-writer
> lock.

What I did was fine-grain locking the double linked list so that you can
delete items without hitting a global lock.

For addition I added per-cpu list-heads that would be spliced onto the
global list once in a while.

Granted, the code was a tad involved... and hch wanted to get rid of
these lists, which is of course a much better solution.

