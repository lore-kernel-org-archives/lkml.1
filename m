Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0BVMfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:35:20 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63320 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0BVMfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:35:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QgeLHUISmtCxIHpP+o/zwWgm2ooh7UcHNDEOwkF4S7IjI1w+M9gZt4qmLz13D4NBRJ
         Lyv40CoKxgyT9k5whh6/1Rq4EOmqVn2aEvwL/IAVLt3jNNpTxQnsyIKbV7w52ApIP8BD
         tjwcMzl/6ru6SceyDYMquJDlLkSOJxay+F5UQ=
Date: Mon, 22 Feb 2010 09:35:00 -0300
From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20100222123500.GA2526@uudg.org>
References: <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
 <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>
 <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain>
 <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>
 <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
 <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
 <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
 <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com>
 <alpine.LFD.2.00.1002221228130.2811@localhost.localdomain>
 <520f0cf11002220423u64daf89dxa6a4249522adabee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <520f0cf11002220423u64daf89dxa6a4249522adabee@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 01:23:33PM +0100, John Kacur wrote:
| On Mon, Feb 22, 2010 at 12:28 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
| > On Mon, 22 Feb 2010, John Kacur wrote:
| >> On Mon, Feb 22, 2010 at 12:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
| >> > We are zooming in, but there is still a way to go!
| >> >
| >>
| >> Woohoo! More -rt fun.
| >>
| >> Unfortunately, I can't log in on my T500 with this kernel though.
| >> The following shows-up on my serial console.
| >> ------------[ cut here ]------------
| >> WARNING: at /home/jkacur/rt.linux.git/net/mac80211/rx.c:2467 ieee80211_rx+0x4c/0
| >> x721 [mac80211]()
| >
| > Fix below. Thanks,
| >
| >    tglx
| > ----
| > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
| > index 82a30c1..e735c17 100644
| > --- a/net/mac80211/rx.c
| > +++ b/net/mac80211/rx.c
| > @@ -2464,7 +2464,7 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
| >        struct ieee80211_supported_band *sband;
| >        struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
| >
| > -       WARN_ON_ONCE(softirq_count() == 0);
| > +       WARN_ON_ONCE_NONRT(softirq_count() == 0);
| >
| >        if (WARN_ON(status->band < 0 ||
| >                    status->band >= IEEE80211_NUM_BANDS))
| > --
| 
| Thanks Thomas
| 
| That patch fixes the symptom I reported, but unfortunately, I still
| can't log-in to my laptop without the machine freezing.
| Not sure why, investigating.

John,

I have a similar issue. But I suspect it may be KMS related (I had a
similar issue on the early 2.6.31-rt days). I also noticed that the
keyboard is kinda crazy (echoing a lot) on console.

As soon as I have more results I will post them here.

Luis
-- 
[ Luis Claudio R. Goncalves             Red Hat  -  Realtime Team ]
[ Fingerprint: 4FDD B8C4 3C59 34BD 8BE9  2696 7203 D980 A448 C8F8 ]

