Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbZDLB7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbZDLB7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 21:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZDLB7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 21:59:03 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:38749 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbZDLB7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 21:59:01 -0400
Date: Sun, 12 Apr 2009 03:58:11 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: tiwai@suse.de
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       alsa-devel@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
Subject: Re: General protection fault when unloading snd_hda_intel on
	2.6.30-rc1+ (bisected)
Message-ID: <20090412015811.GA3907@Pilar.aei.mpg.de>
References: <20090411193630.GA16968@Pilar.aei.mpg.de> <20090411132033.003c581c@infradead.org> <20090411210336.GA15272@Pilar.aei.mpg.de> <20090411143950.3429ebc0@infradead.org> <20090412003320.GA17346@ellpspace.math.ualberta.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412003320.GA17346@ellpspace.math.ualberta.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 11.Apr'09 at 18:33:20 -0600, Michal Jaegermann wrote:
> On Sat, Apr 11, 2009 at 02:39:50PM -0700, Arjan van de Ven wrote:
> > 
> > so... "dev" is pointing evbit at... 697665646632785 which looks like grabage.
> 
> FWIW 697665646632785c decodes in ASCII as "\x2fdevi".

So I painfully (exchanged 'good' for 'bad' in the middle and had
to restart all over) bisected this down to

commit 3be141494a080a9189b51fa78154c975ad8d9806
Author: Takashi Iwai <tiwai@suse.de>
Date:   Fri Feb 20 14:11:16 2009 +0100

    ALSA: hda - Add generic pincfg initialization

    Added the generic pincfg cache and save/restore functions.
    Also introduced the pin-overriding via hwdep sysfs.


It doesn't revert cleanly from the latest kernel, so I could not double 
check it.

OBS: All tests were done with the headphone plugged in.
