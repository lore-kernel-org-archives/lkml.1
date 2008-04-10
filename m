Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYDJObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYDJObU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYDJObL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:31:11 -0400
Received: from styx.suse.cz ([82.119.242.94]:51014 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754814AbYDJObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:31:10 -0400
Date: Thu, 10 Apr 2008 16:31:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Kara <jack@suse.cz>
cc: Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
In-Reply-To: <20080410142700.GC6725@atrey.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee>
 <200804101555.58643.mhocko@suse.cz> <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz>
 <20080410142700.GC6725@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008, Jan Kara wrote:

> > The f_pos races are in fact exploitable, we've already been there. See 
> > for example http://www.isec.pl/vulnerabilities/isec-0016-procleaks.txt
>   Well, this race is more subtle - the window is just one instruction
> wide (stores to f_pos from CPU2 must come between the store of lower and
> upper 32-bits of f_pos on CPU1). And the only result is that f_pos has
> 32-bits from one file pointer and 32-bits from the other one. So I can
> hardly imagine this would be exploitable...

Supposing you are not holding any spinlock and are running with 
preemptible kernel (pretty common scenario nowadays), there is nothing 
that would prevent kernel from rescheduling between the two instructions, 
enlarging the race window to be more comfortable for attacker, right?

I think this is worth fixing.

-- 
Jiri Kosina
SUSE Labs
