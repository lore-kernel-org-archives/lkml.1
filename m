Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0CCOuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:50:52 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:46993 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab0CCOuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:50:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fE8tV0e6Un/EZ4baX2mYk6d8GgMuI1SEUQSIO89NeJoY9vhCQM629RqguSfgzzWz3F
         K9NjpsEGQ4+qaZz9VBEKUlyJ6mZggUe2muD5ZYJ8uCAAG/v4iv6SmDNd3klQNVtnmGqa
         LewVKinYOFeh3yLPNTpKz0IwgLv8hCwLfGkJ4=
Date: Wed, 3 Mar 2010 15:50:46 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Peter Feuerer <peter@piie.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] usb-serial / pl2302 corrupted receive
Message-ID: <20100303145046.GB15162@localhost>
References: <cone.1267466820.296261.3385.1000@deskpiie>
 <20100302235353.GB2196@kroah.com>
 <20100303121441.622e271f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303121441.622e271f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 12:14:41PM +0000, Alan Cox wrote:
> > > Terminal1:
> > > cat /dev/ttyUSB1
> > > 
> > > Terminal2:
> > > while true; do echo 123456789012345678901234567890 > /dev/ttyUSB0 ; done
> > 
> > cat and echo are known to not work well with usb to serial devices.  Can
> > you duplicate this with a "real" tty program like minicom or something
> > else?
> 
> That should no longer be the case. The kfifo buffering implementation
> fixed all the broken internal buffering in the usb tty code - or should
> have done.

Actually, the per-bulk-out-point allocated kfifo is currently unsused for most
drivers, including the pl2303.

I'm responding to this mail with a patch (against 2.6.33) which replaces
the custom fifo-based write implementation in pl2303 with the generic
kfifo based one. I've used it for quite a while now without any problems
(just haven't got around to submitting it).

If Alan's correct, this might solve the echo/cat issue, but either way
it should be applied at some point as it removes a lot of duplicate code.

/Johan

