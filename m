Return-Path: <linux-kernel-owner+w=401wt.eu-S1751371AbZJWI62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbZJWI62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 04:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZJWI61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 04:58:27 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:50886 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZJWI60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 04:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ht9sNF9twfjJSNPiUKCK0/qj0NYdxtSIlrfUPMcgtC7J2UYf+yCm6EvbLVrgW3y1xB
         ZvFqio2Di0ZXVe9aNHPYyC7nEoPr8dTdgdyIhEnGhBDAOuB+ZSKl+MdtBXhrjYm3gV/w
         OIESEM0LRjki1065KWWUjhIH2AB1PfylG7+IU=
Date: Fri, 23 Oct 2009 01:58:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not  work
	anymore
Message-ID: <20091023085824.GA7199@core.coreip.homeip.net>
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <20091015215944.GA9845@core.coreip.homeip.net> <4ADF6237.9070004@tremplin-utc.net> <200910211320.16339.dmitry.torokhov@gmail.com> <4AE0840C.8070801@tremplin-utc.net> <20091022162202.GA18031@core.coreip.homeip.net> <4AE09AFF.805@tremplin-utc.net> <20091022181915.GB18031@core.coreip.homeip.net> <4AE16489.4030008@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AE16489.4030008@tremplin-utc.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 10:08:41AM +0200, Éric Piel wrote:
> Op 22-10-09 20:19, Dmitry Torokhov schreef:
> > On Thu, Oct 22, 2009 at 07:48:47PM +0200, Éric Piel wrote:
> >> I don't think so: xorg 1.6.5, with xinput-evdev 2.2.5. They are both  
> >> latest or second latest stable versions.
> >>
> >> In the log I see this:
> >> (--) SynPS/2 Synaptics TouchPad: touchpad found
> >> (II) PS/2 Generic Mouse: Device reopened after 1 attempts.
> >> (EE) AT Translated Set 2 keyboard: device key_bitmask has changed
> >> (EE) AT Translated Set 2 keyboard: Device has changed - disabling.
> >>
> >> Quite a few people seem to have the same problem.
> > 
> > The bitmask should not be changing on it's own... Any chance you could
> > save contents or /proc/bus/input/devices before suspend and after resume
> > (when X decides to ditch the keyboard) and diff them?
> > 
> Hello,
> I've just tried this: before and after is exactly the same (attached is
> a copy of it).
> 

What about before X starts? Can you please boot into console, kill
hal and udev to make sure they don't mess up with the keymap and, after
doing

	echo -n rescan > /sys/bus/serio/devices/serio0/drvctl

which should completely reinitialize keyboard and compare
/proc/bus/input/devices again? If it is still the same then there must
be a silly bug in X's evdev... But regardless, X policy of comparing
keybit is stupid - they don't kill the device if I change keymap while
in X, why do they do that on resume? Or when I change the limits on
absolute axis... Oh well.

-- 
Dmitry
