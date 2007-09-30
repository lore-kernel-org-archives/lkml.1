Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXI3VoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXI3VoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 17:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbXI3VoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 17:44:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:33076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbXI3VoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:44:07 -0400
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: x86-64 sporadic hang in  2.6.23rc7 and 2.6.22
References: <46F8273B.8030904@aitel.hist.no> <1190669351.4035.254.camel@chaos>
	<46FE5C98.1030507@aitel.hist.no>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 Sep 2007 23:44:04 +0200
In-Reply-To: <46FE5C98.1030507@aitel.hist.no>
Message-ID: <p734phb96cb.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting <helge.hafting@aitel.hist.no> writes:
> 
> shrink_dcache_memory

That usually means random memory corruption from somewhere -- dcache
tends to use a lot of memory and when it is corrupted anywhere these 
functions tend to crash while walking the lists. 

Unfortunately memory corruption is hard to track down because
the messenger is usually not the one to blame.

Perhaps enable slab debugging and see if it turns
something up. Could be also broken hardware. Does an older kernel
run stable? If yes and if it can be reproduced bisecting would
be good.

-Andi
