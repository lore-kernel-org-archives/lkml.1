Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZC3HNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZC3HNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZC3HNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:13:20 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:27571 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbZC3HNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:13:19 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNXfZkKf55cV
X-RZG-CLASS-ID: mo05
Message-ID: <49D0710A.1030805@ursus.ath.cx>
Date: Mon, 30 Mar 2009 09:13:14 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu>
In-Reply-To: <20090330003948.GA13356@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30.03.2009 02:39 Theodore Tso wrote:
> All I can do is apologize to all other filesystem developers profusely
> for ext3's data=ordered semantics; at this point, I very much regret
> that we made data=ordered the default for ext3.  But the application
> writers vastly outnumber us, and realistically we're not going to be
> able to easily roll back eight years of application writers being
> trained that fsync() is not necessary, and actually is detrimental for
> ext3.
>
>   
It seems you still didn't get the point. ext3 data=ordered is not the
problem. The problem is that the average developer doesn't expect the fs
to _re-order_ stuff. This is how most common fs did work long before
ext3 has been introduced. They just know that there is a caching and
they might lose recent data, but they expect the fs on disk to be a
snapshot of the fs in memory at some time before the crash (except when
crashing while writing). But the re-ordering brings it to the state that
never has been in memory. data=ordered is just reflecting this thinking.
With data=writeback as the default the users would have lost data and
would have simply chosen a different fs instead of twisting the params.
Or the distros would have made data=ordered the default to prevent
beeing blamed for the data loss.

And still I don't know any reason, why it makes sense to write the
metadata to non-existing data immediately instead of delaying that, too.

