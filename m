Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbXKVAth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbXKVAth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbXKVAt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:49:27 -0500
Received: from ns.suse.de ([195.135.220.2]:48906 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbXKVAt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:49:26 -0500
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
From: Andi Kleen <andi@firstfloor.org>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com>
Date: Thu, 22 Nov 2007 01:49:25 +0100
In-Reply-To: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> (David Chinner's message of "Thu\, 22 Nov 2007 11\:33\:39 +1100")
Message-ID: <p73oddnhzoq.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:

> To ensure that log I/O is issued as the highest priority I/O, set
> the I/O priority of the log I/O to the highest possible. This will
> ensure that log I/O is not held up behind bulk data or other
> metadata I/O as delaying log I/O can pause the entire transaction
> subsystem. Introduce a new buffer flag to allow us to tag the log
> buffers so we can discrimiate when issuing the I/O.

Won't that possible disturb other RT priority users that do not need 
log IO (e.g. working on preallocated files)? Seems a little
dangerous.

I suspect you want a "higher than bulk but lower than RT" priority
for this really unless there is any block RT priority task waiting
for log IO (but keeping track of the later might be tricky) 

-Andi
