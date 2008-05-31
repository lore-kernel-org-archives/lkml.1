Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYEaM7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYEaM7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 08:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYEaM7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 08:59:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37464 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYEaM7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 08:59:00 -0400
Date: Sat, 31 May 2008 15:58:56 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
In-Reply-To: <20080531125428.GA22111@elte.hu>
Message-ID: <Pine.LNX.4.64.0805311555570.2329@wrl-59.cs.helsinki.fi>
References: <20080526115628.GA31316@elte.hu> <20080529084524.GA24892@elte.hu>
 <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi> <20080529112257.GA18130@elte.hu>
 <20080530181839.GA31915@elte.hu> <20080531060947.GA26441@elte.hu>
 <Pine.LNX.4.64.0805311431100.2329@wrl-59.cs.helsinki.fi>
 <Pine.LNX.4.64.0805311505410.2329@wrl-59.cs.helsinki.fi> <20080531125428.GA22111@elte.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-2033938252-1212238736=:2329"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-2033938252-1212238736=:2329
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 31 May 2008, Ingo Molnar wrote:

> 
> * Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
> 
> > > Btw, does your distcc perhaps happen enable TCP_DEFER_ACCEPT (there 
> > > were some post 2.6.25 changes into it)?
> > 
> > Hmm, if so, please try this revert below (I hope I got everything that 
> > is related there, gitk is currently broken for me so that viewing many 
> > commits quickly is a pain, so I might have accidently missed 
> > something)...
> 
> what is the easiest way to figure out whether my version of distcc 
> enables TCP_DEFER_ACCEPT?

strace distccd (the listening party is the interesting one here, not the 
distcc)?

...setsockopt(listenfd, SOL_TCP, TCP_DEFER_ACCEPT, &val, sizeof(val)) 
seems to be the magic trick that is interestion here.

-- 
 i.
---696208474-2033938252-1212238736=:2329--
