Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbXGBWjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbXGBWjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXGBWi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:38:56 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1867 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbXGBWi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:38:56 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 2 Jul 2007 15:38:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andy Isaacson <adi@hexapodia.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
In-Reply-To: <20070702183835.GM9157@hexapodia.org>
Message-ID: <Pine.LNX.4.64.0707021537350.14774@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
 <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org>
 <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
 <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com>
 <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
 <20070702183835.GM9157@hexapodia.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Andy Isaacson wrote:

> On Sat, Jun 30, 2007 at 12:03:07PM -0700, Davide Libenzi wrote:
> > I think the focus should be to find a case where under the currently 
> > implemented policy for MAP_NOZERO, MAP_NOZERO represent a loss of security 
> > WRT no MAP_NOZERO.   I have not been able to find one yet, although Andy 
> > found a potential one in the setuid+exec/ptrace race (fixed by a patch 
> > that should IMO go in in any case).
> 
> BTW, the ptrace variant of this issue is not a problem -- PTRACE_ATTACH
> running as newuid gets EPERM when trying to attach at /* here */ below.
> 
>     setuid(newuid);
>     /* here */
>     exec(...);
>     exit(1);
> 
> sys_setuid sets current->mm->dumpable = suid_dumpable, so unless the
> admin asked for it, there is no risk WRT PTRACE_ATTACH.  However, this
> risk vector does need to be considered when implementing MAP_NOZERO.

Yes, I missed that. Ptrace is fine there. The 3 lines patch is still 
needed for MAP_NOZERO though.



- Davide


