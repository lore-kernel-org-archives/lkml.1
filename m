Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbXGBXrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbXGBXrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbXGBXq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:46:57 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4234 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbXGBXq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:46:56 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 2 Jul 2007 16:46:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Rik van Riel <riel@redhat.com>
cc: Ulrich Drepper <drepper@gmail.com>, Andy Isaacson <adi@hexapodia.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
In-Reply-To: <4689826C.5050800@redhat.com>
Message-ID: <Pine.LNX.4.64.0707021619590.14774@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> 
 <20070629193954.GL9157@hexapodia.org>  <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
  <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com> 
 <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com> 
 <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com> 
 <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com> 
 <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com>  <20070702190043.GN9157@hexapodia.org>
 <46894BE6.1040302@redhat.com> <a36005b50707021206t417d69ddqcaa8d140e24fa3e3@mail.gmail.com>
 <Pine.LNX.4.64.0707021540560.14774@alien.or.mcafeemobile.com>
 <4689826C.5050800@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Rik van Riel wrote:

> Davide Libenzi wrote:
> > On Mon, 2 Jul 2007, Ulrich Drepper wrote:
> > 
> > > On 7/2/07, Rik van Riel <riel@redhat.com> wrote:
> > > > That should not happen.  The default SELinux configuration
> > > > in Fedora (and Debian?) runs a few daemons in their own
> > > > restricted modes and has most of the system running in
> > > > unconfined_t, including the majority of user programs.
> > > This is the state as of F7.  This will change hopefully soon.
> > > Programs like firefox run by normal users must be confined, to. Any
> > > tests using security must be fast, it's not something which is done
> > > only for a few apps.
> > 
> > The strong requirement would be that the cookie is not a bit longer than
> > sizeof(unsigned long).
> 
> You could easily replace the cookie with a pointer to a free
> page pool.

You talked about this pool even before, but honestly I don't see how it 
can help.
Pools requires management (mainly flush under pressure), and it wouldn't 
really do any benefit. Don't we already have enough pools in the 
allocation path?
The pool has to be UID (or cookie/whatever) based [1], so on top of the 
pool lookup/management code, you'll have another lock to be taken (the 
pool one). So using the UID (cookie) is simpler, faster and requires no 
extra code.
A simple numeric cookie virtually creates "pools" w/out requiring extra 
code. Yes, having really separate pool helps the recycle efficency, but 
I'm not sure that's worth the extra code.



[1] An mm_struct based pool would be clearly useless


- Davide


