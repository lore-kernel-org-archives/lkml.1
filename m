Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYJAIco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYJAIco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYJAIcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:32:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38237 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbYJAIcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:32:35 -0400
Date: Wed, 1 Oct 2008 10:32:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] pcm_native: label out defined but not used
Message-ID: <20081001083224.GC31009@elte.hu>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net> <20081001075921.GA25832@elte.hu> <s5h63ocd96s.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h63ocd96s.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takashi Iwai <tiwai@suse.de> wrote:

> At Wed, 1 Oct 2008 09:59:21 +0200,
> Ingo Molnar wrote:
> > 
> > 
> > (Cc:-ed Taskashi for this ALSA cleanup patch.)
> 
> This label is used when the debug option is enabled.

ah, indeed:

        snd_assert(substream != NULL, goto out);

if then i'd suggest to clean it up like this:

        if (snd_assert(substream != NULL))
		goto out;

this is how DEBUG_LOCKS_WARN_ON() is used in kernel/lockdep.c for 
example. Putting code flow side-effects into debug macros looks a bit 
weird.

	Ingo
