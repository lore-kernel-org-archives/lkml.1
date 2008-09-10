Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYIJNOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYIJNOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYIJNOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:14:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYIJNOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:14:38 -0400
Date: Wed, 10 Sep 2008 09:14:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jarod Wilson <jwilson@redhat.com>
Cc: Ville Syrj?l? <syrjala@sci.fi>, Janne Grunau <j@jannau.net>,
       linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Message-ID: <20080910131432.GA2161@infradead.org>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-7-git-send-email-jwilson@redhat.com> <20080910095832.GA22422@sci.fi> <200809100905.58304.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809100905.58304.jwilson@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 09:05:58AM -0400, Jarod Wilson wrote:
> True, though I think some users still prefer using them with the lirc drivers 
> for assorted reasons. Configuring something like mythtv to work with the 
> ati_remote{,2} driver appears to be a bit more complex (or at least non-
> standard vs. several other popular remotes) and not as functional vs. 
> configuring mythtv w/lirc_atiusb.

Bad idea to have two drivers for the same piece of hardware.  And this
gets straight back into the why should lirc be different from the input
layer point raised earlies.  I think we really shouldn't keep lirc as
a separate subsystem, but make sure all the drivers are written to the
input layer.  To make the migration easier for exiting users we could
add a /dev/lirc driver ontop of the input layer, similar to how the ps2
mouse and joystick drivers sit ontop of the input core.

