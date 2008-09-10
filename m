Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYIJNop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYIJNop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYIJNoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:44:22 -0400
Received: from scing.com ([217.160.110.58]:46168 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbYIJNoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:44:21 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Date: Wed, 10 Sep 2008 15:44:17 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>,
       Ville =?iso-8859-1?q?Syrj=E4l=E4?= <syrjala@sci.fi>,
       linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <200809100905.58304.jwilson@redhat.com> <20080910131432.GA2161@infradead.org>
In-Reply-To: <20080910131432.GA2161@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101544.17704.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 15:14:32 Christoph Hellwig wrote:
> On Wed, Sep 10, 2008 at 09:05:58AM -0400, Jarod Wilson wrote:
> > True, though I think some users still prefer using them with the
> > lirc drivers for assorted reasons. Configuring something like
> > mythtv to work with the ati_remote{,2} driver appears to be a bit
> > more complex (or at least non- standard vs. several other popular
> > remotes) and not as functional vs. configuring mythtv
> > w/lirc_atiusb.
>
> Bad idea to have two drivers for the same piece of hardware.  And
> this gets straight back into the why should lirc be different from
> the input layer point raised earlies.  I think we really shouldn't
> keep lirc as a separate subsystem, but make sure all the drivers are
> written to the input layer.

Some drivers don't report events but deliver the signal to the lirc 
daemon. The daemon decodes the signal. Decoding of several IR protocols 
and mapping of each possible remote to events are things much easier 
done in userspace.
Aslo LIRC is not only about IR input but also output.

See following mail from Christoph Bertelmus for more details.
http://sourceforge.net/mailarchive/message.php?msg_id=AAryKgq9UOB%40bartelmus.de

> To make the migration easier for exiting 
> users we could add a /dev/lirc driver ontop of the input layer,

This shouldn't be necessary since the lirc daemon can already read from 
input devices.

Janne
