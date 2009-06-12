Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbZFLMRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbZFLMRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZFLMRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:17:07 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48434 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZFLMRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=r4PYEUKrYKKqRdOYRaudkT+T1w4aAhk/3sWGPj0s7zVQvYVc0wHl1RDBCteJFvk6by
         oqsJYPadjXMxO0cMO/hn0HUjg7pglXSCd2LkujMtynNhwFMhxxPa7z94kjoFFrHvGjZ/
         z8cNWG/fAfdchtXb9E0rPGZ/Cn59O5kMC7olE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
Date: Fri, 12 Jun 2009 13:44:25 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090611-07944-gc1b019d-dirty; KDE/4.2.3; i686; ; )
Cc: Sven =?iso-8859-1?q?K=F6hler?= <sven.koehler@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <20090610.112804.193703669.davem@davemloft.net> <4A317949.9090301@gmail.com> <s5hzlcedxqn.wl%tiwai@suse.de>
In-Reply-To: <s5hzlcedxqn.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906121344.26139.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 12 June 2009 03:52:48 Takashi Iwai wrote:
> At Thu, 11 Jun 2009 23:38:17 +0200,
> Sven Köhler wrote:
> > 
> > >>>> Can somebody point out, how I can set this xrun_debug thing or can
> > >>>> somebody provide a patch that reverts the change?
> > >>> Did you read my reply to David?
> > >> I will try, what is described there and I will report back if I get any
> > >> debug output.
> > > 
> > > Thanks, that'll be be helpful.
> > 
> > Below is the output. Note, that audacious 2.x was not only skipping a
> > little bit. In fact, the clock that was showing the time of audio played
> > was running twice as fast or even 4 times as fast. The sound was played
> > at the right samplerate but in fast it seems, that much of the audio
> > data was skipped and I only heard a series of short fragments of what
> > should have been the song I'm listening to.
> > 
> > 
> > PCM: hw_ptr skipping! (pos=4096, delta=7169, period=1024, jdelta=0/149)
> 
> OK, it must be the same problem indeed as David and Bartlomiej see.
> 
> Although Bartlomiej wrote that reverting the commit below didn't help,
> I still suspect it comes from there.
>      commit da2436a23c038055b1da6fe30b6ea2886b1e07b0
>      Author: Jaroslav Kysela <perex@perex.cz>
>      Date:   Mon Apr 13 21:31:25 2009 +0200
>      [ALSA] intel8x0: do not use zero value from PICB register
> 
> The below is a revised patch to fix the possible regression from this.
> Could you guys give it a try, or check reverting the above?

The issue is still present with the revised patch.
