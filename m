Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbYHCRdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbYHCRdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbYHCRda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:33:30 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:38014 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbYHCRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:33:29 -0400
Date: Sun, 3 Aug 2008 19:33:19 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH] ALSA: pcm_native: remove unused label
In-Reply-To: <alpine.LNX.1.10.0808031921280.7765@titan.stealer.net>
Message-ID: <alpine.LNX.1.10.0808031931150.7765@titan.stealer.net>
References: <20080803164719.GA5414@joi> <alpine.LNX.1.10.0808031921280.7765@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 03 Aug 2008 17:33:28 +0000
	Bayes: 0.0001 Tokens: new, 202; hammy, 7; neutral, 2; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
X-Spam-Signature: a1176e65e896c7a9f348feb96e16aff7387ca147
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Aug 2008, Sven Wegener wrote:

> On Sun, 3 Aug 2008, Marcin Slusarz wrote:
> 
> > gcc warns about it:
> > sound/core/pcm_native.c: In function 'snd_pcm_fasync':
> > sound/core/pcm_native.c:3262: warning: label 'out' defined but not used
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Takashi Iwai <tiwai@suse.de>
> > Cc: Jaroslav Kysela <perex@perex.cz>
> > ---
> >  sound/core/pcm_native.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> > index c49b9d9..333cff6 100644
> > --- a/sound/core/pcm_native.c
> > +++ b/sound/core/pcm_native.c
> > @@ -3259,7 +3259,6 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
> >  	runtime = substream->runtime;
> >  
> >  	err = fasync_helper(fd, file, on, &runtime->fasync);
> > -out:
> >  	unlock_kernel();
> >  	if (err < 0)
> >  		return err;
> 
> Uhm, no, there's
> 
> snd_assert(substream != NULL, goto out);
> 
> one line above your context.

And that is broken. That's not what an assert is for, we access 
substream->runtime a line later and that will blow up. That should be a 
simpe if, instead of an assert.

Sven
