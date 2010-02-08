Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0BHUen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:34:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46161
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886Ab0BHUel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:34:41 -0500
Date: Mon, 08 Feb 2010 12:34:54 -0800 (PST)
Message-Id: <20100208.123454.38911094.davem@davemloft.net>
To: rjw@sisk.pl
Cc: htd@fancy-poultry.org, xtfeng@gmail.com, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, maciej.rutecki@gmail.com,
       netdev@vger.kernel.org
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002081204.28039.rjw@sisk.pl>
References: <445R0ey9hAI.A.tNB.XozbLB@chimera>
	<20100208071515.GA6473@fancy-poultry.org>
	<201002081204.28039.rjw@sisk.pl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 8 Feb 2010 12:04:27 +0100

> Hmm.  The bug is in net/dccp/ccid.c, so it looks like something for the
> networking guys to merge.
> 
> Any chance to send a singed-off version of the patch do David?

Fixes for this are already in my net-2.6 tree, will send them
off to Linus later today, I was waiting for some netfilter
fixes which I just received:

commit 1386be55e32a3c5d8ef4a2b243c530a7b664c02c
Author: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Date:   Tue Feb 2 20:16:56 2010 +0000

    dccp: fix auto-loading of dccp(_probe)
    
    This fixes commit (38ff3e6bb987ec583268da8eb22628293095d43b) ("dccp_probe:
    Fix module load dependencies between dccp and dccp_probe", from 15 Jan).
    
    It fixes the construction of the first argument of try_then_request_module(),
    where only valid return codes from the first argument should be returned.
    
    What we do now is assign the result of register_jprobe() to ret, without
    the side effect of the comparison.
    
    Acked-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 8ed030dd0aa400d18c63861c2c6deb7c38f4edde
Author: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Date:   Mon Feb 1 02:12:19 2010 +0000

    dccp: fix bug in cache allocation
    
    This fixes a bug introduced in commit de4ef86cfce60d2250111f34f8a084e769f23b16
    ("dccp: fix dccp rmmod when kernel configured to use slub", 17 Jan): the
    vsnprintf used sizeof(slab_name_fmt), which became truncated to 4 bytes, since
    slab_name_fmt is now a 4-byte pointer and no longer a 32-character array.
    
    This lead to error messages such as
     FATAL: Error inserting dccp: No buffer space available
    
     >> kernel: [ 1456.341501] kmem_cache_create: duplicate cache cci
    generated due to the truncation after the 3rd character.
    
    Fixed for the moment by introducing a symbolic constant. Tested to fix the bug.
    
    Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
    Acked-by: Neil Horman <nhorman@tuxdriver.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

