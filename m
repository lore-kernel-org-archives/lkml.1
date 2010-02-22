Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0BVLaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 06:30:00 -0500
Received: from www.tglx.de ([62.245.132.106]:42598 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab0BVL37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 06:29:59 -0500
Date: Mon, 22 Feb 2010 12:28:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
In-Reply-To: <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002221228130.2811@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>  <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>  <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> 
 <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>  <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain>  <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>  <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain> 
 <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>  <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain> <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, John Kacur wrote:
> On Mon, Feb 22, 2010 at 12:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > We are zooming in, but there is still a way to go!
> >
> 
> Woohoo! More -rt fun.
> 
> Unfortunately, I can't log in on my T500 with this kernel though.
> The following shows-up on my serial console.
> ------------[ cut here ]------------
> WARNING: at /home/jkacur/rt.linux.git/net/mac80211/rx.c:2467 ieee80211_rx+0x4c/0
> x721 [mac80211]()

Fix below. Thanks,

    tglx
----
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 82a30c1..e735c17 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2464,7 +2464,7 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	WARN_ON_ONCE(softirq_count() == 0);
+	WARN_ON_ONCE_NONRT(softirq_count() == 0);
 
 	if (WARN_ON(status->band < 0 ||
 		    status->band >= IEEE80211_NUM_BANDS))
