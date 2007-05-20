Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXETE6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXETE6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 00:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbXETE6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 00:58:34 -0400
Received: from smtp.osdl.org ([207.189.120.12]:35959 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559AbXETE6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 00:58:33 -0400
Date: Sat, 19 May 2007 21:57:37 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, auke-jan.h.kok@intel.com, doug.chapman@hp.com,
       cramerj@intel.com, john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, e1000-devel@lists.sourceforge.net,
       bcollins@ubuntu.com, yoshfuji@linux-ipv6.org
Subject: Re: [5/5] 2.6.22-rc2: known regressions
Message-ID: <20070519215737.5a98a070@freepuppy>
In-Reply-To: <20070519.153829.112852602.davem@davemloft.net>
References: <464F6DC9.80805@googlemail.com>
	<464F74E9.8080102@googlemail.com>
	<20070519.153829.112852602.davem@davemloft.net>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 15:38:29 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Date: Sun, 20 May 2007 00:06:33 +0200
> 
> > Subject    : OOPS triggered by ip(8) deconfiguring a network interface
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8491
> > Submitter  : Ben Collins <bcollins@ubuntu.com>
> > Status     : Unknown
> 
> Might be fixed by:
> 
> 	http://marc.info/?l=linux-netdev&m=117915849224816&w=2
> 
> I'll merge that patch in and we'll see what happens.
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks more like the IPV6 SNMP6 OOPS, I saw and fixed with:

commit 5632c5152aa621885d87ea0b8fdd5a6bb9f69c6f
Author: Stephen Hemminger <shemminger@linux-foundation.org>
Date:   Sat Apr 28 21:16:39 2007 -0700

    [IPV6]: Track device renames in snmp6.
    
    When network device's are renamed, the IPV6 snmp6 code
    gets confused. It doesn't track name changes so it will OOPS
    when network device's are removed.
    
    The fix is trivial, just unregister/re-register in notify handler.
    
    Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
