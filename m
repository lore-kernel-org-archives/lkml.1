Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbXGBSip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbXGBSip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 14:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXGBSih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 14:38:37 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:32372 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXGBSig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 14:38:36 -0400
Date: Mon, 2 Jul 2007 11:38:35 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Message-ID: <20070702183835.GM9157@hexapodia.org>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org> <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com> <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com> <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-PGP-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 12:03:07PM -0700, Davide Libenzi wrote:
> I think the focus should be to find a case where under the currently 
> implemented policy for MAP_NOZERO, MAP_NOZERO represent a loss of security 
> WRT no MAP_NOZERO.   I have not been able to find one yet, although Andy 
> found a potential one in the setuid+exec/ptrace race (fixed by a patch 
> that should IMO go in in any case).

BTW, the ptrace variant of this issue is not a problem -- PTRACE_ATTACH
running as newuid gets EPERM when trying to attach at /* here */ below.

    setuid(newuid);
    /* here */
    exec(...);
    exit(1);

sys_setuid sets current->mm->dumpable = suid_dumpable, so unless the
admin asked for it, there is no risk WRT PTRACE_ATTACH.  However, this
risk vector does need to be considered when implementing MAP_NOZERO.

-andy
