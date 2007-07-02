Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbXGBTD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbXGBTD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXGBTDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:03:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbXGBTDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:03:20 -0400
Message-ID: <46894BE6.1040302@redhat.com>
Date: Mon, 02 Jul 2007 15:03:02 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Kyle Moffett <mrmacman_g4@mac.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org> <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com> <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com> <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com> <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com> <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com> <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com> <20070702190043.GN9157@hexapodia.org>
In-Reply-To: <20070702190043.GN9157@hexapodia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Isaacson wrote:
> On Sat, Jun 30, 2007 at 08:21:52PM -0400, Kyle Moffett wrote:
>> That's why you'd need to call an LSM hook to get a unique identifier,  
>> as the LSM would actually need to allocate identifiers for  
>> equivalence classes.  Secondly, processes may change labels as they  
>> run, so you couldn't just call it once and cache the result, you  
>> would need to call it for every freed page (or every re-use of a page).
> 
> Davide's patch adds a owner_uid field to mm_struct.  Assuming that turns
> into a "mm security equivalence class identifier", the LSM can simply
> update it when a label-change-event occurs.  No need to call out to
> (potentially heavyweight!) LSM code in page allocation critical paths.
> 
> I'm a bit concerned that tracking the equivalence classes will get
> expensive.  I think you can end up with quadratic explosion in the worst
> case (every user using every permutation of LSM bits).

That should not happen.  The default SELinux configuration
in Fedora (and Debian?) runs a few daemons in their own
restricted modes and has most of the system running in
unconfined_t, including the majority of user programs.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
