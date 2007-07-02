Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXGBWqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXGBWqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXGBWqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:46:08 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4739 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXGBWqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:46:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 2 Jul 2007 15:46:02 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Rik van Riel <riel@redhat.com>, Andy Isaacson <adi@hexapodia.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
In-Reply-To: <a36005b50707021206t417d69ddqcaa8d140e24fa3e3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707021540560.14774@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> 
 <20070629193954.GL9157@hexapodia.org>  <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
  <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com> 
 <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com> 
 <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com> 
 <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com> 
 <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com>  <20070702190043.GN9157@hexapodia.org>
 <46894BE6.1040302@redhat.com> <a36005b50707021206t417d69ddqcaa8d140e24fa3e3@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Ulrich Drepper wrote:

> On 7/2/07, Rik van Riel <riel@redhat.com> wrote:
> > That should not happen.  The default SELinux configuration
> > in Fedora (and Debian?) runs a few daemons in their own
> > restricted modes and has most of the system running in
> > unconfined_t, including the majority of user programs.
> 
> This is the state as of F7.  This will change hopefully soon.
> Programs like firefox run by normal users must be confined, to. Any
> tests using security must be fast, it's not something which is done
> only for a few apps.

The strong requirement would be that the cookie is not a bit longer than 
sizeof(unsigned long).
For the "equality" check, this better be "==", although it could be 
abstracted in a function/macro that SeLinux implements in a different way.
But this "equality" check is done a page-fault time, so it better be 
pretty quick (otherwise if they bloat that path, they probably be better 
of not using MAP_NOZERO at all).



- Davide


