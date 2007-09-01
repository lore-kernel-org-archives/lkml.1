Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbXIAWUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbXIAWUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbXIAWUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:20:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:49996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194AbXIAWUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:20:24 -0400
To: Daniel Drake <ddrake@brontes3d.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: speeding up swapoff
References: <1188394172.22156.67.camel@localhost>
	<20070829073040.1ec35176@laptopd505.fenrus.org>
	<1188398683.22156.77.camel@localhost>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Sep 2007 00:20:22 +0200
In-Reply-To: <1188398683.22156.77.camel@localhost>
Message-ID: <p73fy1yvxi1.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake <ddrake@brontes3d.com> writes:
> 
> It's more-or-less a real life problem. We have an interactive
> application which, when triggered by the user, performs rendering tasks
> which must operate in real-time. In attempt to secure performance, we
> want to ensure everything is memory resident and that nothing might be
> swapped out during the process. So, we run swapoff at that time.

If the system gets under serious memory pressure it'll happily discard
your text pages too (and later reload them from disk). The same
for any file data you might need to access.

swapoff will only affect anonymous memory, but not all the other
memory you'll need as well.

There's no way around mlock/mlockall() to really prevent this.

Still even with that you could still lose dentries/inodes etc which
can also cause stalls. The only way to keep them locked
is to keep the files always open.

-Andi
