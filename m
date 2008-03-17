Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYCQVIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYCQVIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYCQVIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:08:43 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:34463 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYCQVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:08:43 -0400
To: Jeff Dike <jdike@addtoit.com>
Cc: clowncoder <vincent-perrier@club-internet.fr>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@timesys.com>
Subject: Re: [2.6.24.x] UML select()/poll() oversleeping reproducibly
References: <47B34BA0.30006@club-internet.fr>
	<20080214003853.GA15952@c2.user-mode-linux.org>
	<47B4BDCD.4080605@club-internet.fr>
	<20080215160205.GA6082@c2.user-mode-linux.org>
	<47B5CE40.9000005@club-internet.fr>
	<20080215184650.GA8810@c2.user-mode-linux.org>
	<87y78kx640.fsf_-_@hades.wkstn.nix>
	<20080317193415.GA12234@c2.user-mode-linux.org>
From: Nix <nix@esperi.org.uk>
Emacs: ... it's not just a way of life, it's a text editor!
Date: Mon, 17 Mar 2008 21:08:16 +0000
In-Reply-To: <20080317193415.GA12234@c2.user-mode-linux.org> (Jeff Dike's message of "Mon, 17 Mar 2008 15:34:15 -0400")
Message-ID: <87k5k112kf.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc1-Metrics: hades 1182; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Mar 2008, Jeff Dike verbalised:

> Below is the same patch with another kluge, which cuts down the
> requested sleep by 10% in hopes of getting the actual sleep closer to
> what's wanted.

Eeuuuuw. :)

> This is unusable in anything resembling mainline, but I'd like to see
> how your various systems react to it.  I'm getting very close to the
> sleeps I asked for (with slight undersleeping, which is a bug).

OK.

Tests on host with clocksource pit:

bash-3.2# bin/select-sleep 5
Slept for 5 seconds.
bash-3.2# bin/select-sleep 10
Slept for 11 seconds.
bash-3.2# bin/select-sleep 30
Slept for 31 seconds.
bash-3.2# bin/select-sleep 60
Slept for 61 seconds.

... so much better than the 4x error without this patch.

Tests on host with clocksource tsc:

bash-3.2# bin/select-sleep 5
Slept for 5 seconds.
bash-3.2# bin/select-sleep 10
Slept for 10 seconds.
bash-3.2# bin/select-sleep 30
Slept for 30 seconds.
bash-3.2# bin/select-sleep 60
Slept for 61 seconds.

Distinctly better than without this patch.

(Am I the only person who finds it strange that (some) clocksource
hackers are arguing about accuracy problems in the ppm range while we're
glad to get an error of `only' single seconds per minute out of it? 
Maybe next year we can invent the `pendulum' clocksource :) )

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
