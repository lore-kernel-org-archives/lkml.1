Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYIJOQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYIJOQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYIJOQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:16:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45216 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbYIJOQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:16:06 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Date: Wed, 10 Sep 2008 10:13:18 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
       Ville =?iso-8859-1?q?Syrj=E4l=E4?= <syrjala@sci.fi>,
       linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <20080910131432.GA2161@infradead.org> <200809101544.17704.j@jannau.net>
In-Reply-To: <200809101544.17704.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101013.19205.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 09:44:17 Janne Grunau wrote:
> On Wednesday 10 September 2008 15:14:32 Christoph Hellwig wrote:
> > On Wed, Sep 10, 2008 at 09:05:58AM -0400, Jarod Wilson wrote:
> > > True, though I think some users still prefer using them with the
> > > lirc drivers for assorted reasons. Configuring something like
> > > mythtv to work with the ati_remote{,2} driver appears to be a bit
> > > more complex (or at least non- standard vs. several other popular
> > > remotes) and not as functional vs. configuring mythtv
> > > w/lirc_atiusb.
> >
> > Bad idea to have two drivers for the same piece of hardware.  And
> > this gets straight back into the why should lirc be different from
> > the input layer point raised earlies.  I think we really shouldn't
> > keep lirc as a separate subsystem, but make sure all the drivers are
> > written to the input layer.
>
> Some drivers don't report events but deliver the signal to the lirc
> daemon. The daemon decodes the signal. Decoding of several IR protocols
> and mapping of each possible remote to events are things much easier
> done in userspace.
> Aslo LIRC is not only about IR input but also output.
>
> See following mail from Christoph Bertelmus for more details.
> http://sourceforge.net/mailarchive/message.php?msg_id=AAryKgq9UOB%40bartelm
>us.de

Yeah, I think that pretty well covers the issues.

> > To make the migration easier for exiting
> > users we could add a /dev/lirc driver ontop of the input layer,
>
> This shouldn't be necessary since the lirc daemon can already read from
> input devices.

Okay, so what I'm hearing and thinking is that we should at drop lirc_atiusb 
from consideration for inclusion, and instead extend ati_remote{,2} as/if 
necessary to be able to let the lirc daemon use it via the provided input 
device, so people can get the best of both worlds (it behaves like a keyboard 
if so configured, talks to lircd if so configured).

-- 
Jarod Wilson
jarod@redhat.com

