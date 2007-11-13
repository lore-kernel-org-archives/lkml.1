Return-Path: <linux-kernel-owner+w=401wt.eu-S1763019AbXKMVco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763019AbXKMVco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761462AbXKMVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:32:25 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:51593 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760655AbXKMVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:32:21 -0500
Subject: Re: [BUG] New Kernel Bugs
From: Romano Giannetti <romanol@upcomillas.es>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, "Giacomo A. Catenazzi" <cate@cateee.net>,
       Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20071113170141.GD4250@stusta.de>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	 <20071113.033946.114918709.davem@davemloft.net>
	 <20071113034916.2556edd7.akpm@linux-foundation.org>
	 <20071113.035824.40509981.davem@davemloft.net>
	 <20071113041259.79c9a8c5.akpm@linux-foundation.org>
	 <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca>
	 <4739C1B0.8000803@cateee.net>
	 <2c0942db0711130757g295add20re0ee423b84921d28@mail.gmail.com>
	 <20071113170141.GD4250@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 13 Nov 2007 18:50:38 +0100
Message-Id: <1194976238.15745.17.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I jump in this discussion hoping to have some more insight on git and to
report my experience as a tester. I consider myself as half-literate in
this (I am here since 1991, more or less, and I am able to compile a
kernel and even hand-apply a patch, although I am in no way a kernel
programmer). 

On Tue, 2007-11-13 at 18:01 +0100, Adrian Bunk wrote:

> The small instruction below is enough for everyone who is able to 
> build his own kernel to do a git bisect.

> # start bisecting:
> cd linux-2.6
> git bisect start
> git bisect bad v2.6.21
> git bisect good v2.6.20
> cp /path/to/.config .
> 

This was what I did in my (in the end almost successful) bisecting when
trying to find the mmc problem (see the thread named "2.6.24-rc1 eat my
SD card"). This is true in theory, but it has some problem. The "this
commit does not compile is the easiest and in man git-bisect it's
explained how to solve it. The changes in .config options, added or
removed, are another problem when jumping back and forth from version (I
was bitten by the gadzillions new options added to hda-intel alsa
driver, but well, that is solvable with a bit of attention).

The main problem I had, and that stopped me to arrive to a definite is
this situation:

j version-bad
i
h
g unrelated (but similar) bug corrected
f
e
d unrelated (but similar) bug introduced
c
b
a version-good 

(d was the series to change drivers to use sg helpers, and g was a "fix
fallout from sg helpers" patch). Now I have a series of kernels (d, e,
f) that did not work at all and so I cannot mark them good or bad. With
the number of patches added in the free-for-all week, this is a very
probable scenario. There is a way out from this using bisect?

Romano 

PS as a suggestion, I think that added a "Reported-by", or "Tested-by",
or "Debugged-by" attribution in the repository, as happened to be in the
MMC case, is a nice an d welcomed reward for the effort.    

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
