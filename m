Return-Path: <linux-kernel-owner+w=401wt.eu-S1766791AbXDSPiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766791AbXDSPiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766819AbXDSPiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:38:09 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:51417 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766791AbXDSPiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:38:08 -0400
Message-ID: <46278CDD.2000007@gmail.com>
Date: Thu, 19 Apr 2007 17:38:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: johann deneux <johann.deneux@gmail.com>, linux-kernel@vger.kernel.org,
       stenyak@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
References: <210731960111436322@karneval.cz> <462688AB.4060707@gmail.com> <38b3b7c0704182125q1928c5barad21ed603088ab04@mail.gmail.com> <200704190058.11625.dtor@insightbb.com>
In-Reply-To: <200704190058.11625.dtor@insightbb.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov napsal(a):
> I have been thinking about this and I don't think that exporting motor
> data is a good idea, at least not in case of Phantom driver. The fact
> that there are 3 motors is a hardware implementation detail and it
> is not interesting for general application.

Ok, so what about torques (despite it's still something like FF_RAW or motor
descriptor)? It seems not to be so bad called effect name -- not only
phantom uses torques on motors as an unit of force, for example I get this
by quick googling:
http://www.caip.rutgers.edu/~bouzit/lrp/glove.html
They use there some motors with 14 torque values too, so the phantom isn't
the only device which uses this approach.

> My understanding that the end result of controlling these 3 motors

Actually there is also a version with 6 motors :).

> is a force vector (I don't know if there is such english term, this
> is a literal translation from russian) applied to user's hand.

Better say torques vector. You must compute a torque for each place from the
3d (or bigger) vector of forces in different way for each device that exists
-- this means forces are not independent unit, torques are in the meaning of
layer which doesn't care about what is connected above and below it.

> If we are interested in using FF API we need to come up with a way
> to express this effect without exposing implementation details of
> one particular device.

Still, torques are better named raw/motor values, which goes to the device
and I'm sceptic about inventing something class-better than this.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E


