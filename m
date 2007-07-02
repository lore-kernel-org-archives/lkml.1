Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbXGBTAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbXGBTAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbXGBTAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:00:45 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:35085 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbXGBTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:00:44 -0400
Date: Mon, 2 Jul 2007 12:00:43 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Message-ID: <20070702190043.GN9157@hexapodia.org>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org> <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com> <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com> <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com> <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com> <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com> <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-PGP-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 08:21:52PM -0400, Kyle Moffett wrote:
> That's why you'd need to call an LSM hook to get a unique identifier,  
> as the LSM would actually need to allocate identifiers for  
> equivalence classes.  Secondly, processes may change labels as they  
> run, so you couldn't just call it once and cache the result, you  
> would need to call it for every freed page (or every re-use of a page).

Davide's patch adds a owner_uid field to mm_struct.  Assuming that turns
into a "mm security equivalence class identifier", the LSM can simply
update it when a label-change-event occurs.  No need to call out to
(potentially heavyweight!) LSM code in page allocation critical paths.

I'm a bit concerned that tracking the equivalence classes will get
expensive.  I think you can end up with quadratic explosion in the worst
case (every user using every permutation of LSM bits).

-andy
