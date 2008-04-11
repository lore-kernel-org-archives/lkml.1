Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbYDKNrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbYDKNrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYDKNr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:47:26 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46103 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112AbYDKNrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:47:25 -0400
Date: Fri, 11 Apr 2008 09:47:24 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-ID: <20080411134724.GF2160@csclub.uwaterloo.ca>
References: <20080410160630.GA24885@enneenne.com> <1207851751-25703-1-git-send-email-giometti@linux.it> <1207851751-25703-2-git-send-email-giometti@linux.it> <1207851751-25703-3-git-send-email-giometti@linux.it> <1207851751-25703-4-git-send-email-giometti@linux.it> <1207851751-25703-5-git-send-email-giometti@linux.it> <1207851751-25703-6-git-send-email-giometti@linux.it> <20080410210918.3be98868@core> <20080411075515.GH26777@enneenne.com> <20080411092840.3cc4de67@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411092840.3cc4de67@core>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 09:28:40AM +0100, Alan Cox wrote:
> I do not want PPS code adding to every single serial driver. That way
> lies madness. We do it once, and in the right layer. I'll take a further
> look at it after the tty->ops patch is merged. At that point we'll be in
> a good position to add the needed ops/callbacks.

I thought it just required that the uart driver call
uart_handle_dcd_change when the state of the CD changes, and all the PPS
stuff happened in that function.

That seems pretty low intrusion, since the serial driver wouldn't need
to be touched with the PPS code at all as long as it already calls the
uart_handle functions.

Now if the driver doesn't generate an IRQ whenever a status line
changes, then the driver does need to be updated to do that.  Some (like
jsm) already do, and have no need for the HARDPPS setting at all.  It
seems reasonable though that the serial drivers should already have had
support for generating interrupts when a status line changes.

-- 
Len Sorensen
