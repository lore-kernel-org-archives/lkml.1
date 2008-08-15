Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYHOLt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYHOLt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYHOLts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:49:48 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:61061 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYHOLtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g5Wu1McGgHoD5JqQHk2q0qa1B4sOMH+sZ5ghFLsebgPj5lHGFu26C2W1XUB2QnxN88
         lcX5thtHLNE5JzG/gMFgLkcLDcv3YOUjF/ibqlB2lwra1GWDRnyAoJWdyzf9EyIG6jla
         JPsYP0596k4bMouGAki3UsiFk1T9xWNtBCz2I=
Subject: RE: Possible CPU_IDLE bug [WAS: Re: Timer unstability on
	when	using C2	and deeper sleep states (Dell Latitude XT)]
From: Milan Plzik <milan.plzik@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC460945BFF2@orsmsx505.amr.corp.intel.com>
References: <1218566008.13866.41.camel@localhost>
	 <1218625125.4304.7.camel@localhost> <1218636980.5250.12.camel@localhost>
	 <7E82351C108FA840AB1866AC776AEC460945BB44@orsmsx505.amr.corp.intel.com>
	 <1218658873.4336.15.camel@localhost>
	 <7E82351C108FA840AB1866AC776AEC460945BFF2@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 13:46:51 +0200
Message-Id: <1218800811.4388.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On St, 2008-08-13 at 14:22 -0700, Pallipadi, Venkatesh wrote:
> 
> >-----Original Message-----
> >From: Milan Plzik [mailto:milan.plzik@gmail.com]
> >Sent: Wednesday, August 13, 2008 1:21 PM
> >To: Pallipadi, Venkatesh
> >Cc: linux-kernel@vger.kernel.org
> >Subject: RE: Possible CPU_IDLE bug [WAS: Re: Timer unstability
> >on when using C2 and deeper sleep states (Dell Latitude XT)]
> >

[...]

> Were all these tests with 2.6.26? Can you try with 2.6.27-rc3?
> 
> There is one bugfix patch that, IIRC, went in after 2.6.26.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b8f8c3cf0a4ac0632ec3f0e15e9dc0c29de917af

  I did some further testing on 2.6.27-rc3 today; unfortunately I found
out that the 'press key or I won't move' issue is still present,
although I have not noticed it first time.

  I tried to switch cpuidle governors on the fly and found out one
interesting thing -- if powertop shows ~ 10000 wakeups/sec and I just
play with the governors (I just echo "menu" or "ladder"
> /sys/devices/system/cpu/cpuidle/current_governor), with non-zero
probability (usually second attempt made it) the number of wakeups/sec
changes to more reasonable value, roughly 700. But this happened even if
I echoed the same name as the current governor is, which is a bit
strange, as this is (according to sources) basically NOOP -- it just
locks and unlocks the cpuidle_lock mutex.

  Interesting also is, that no matter in what state I was (menu governor
giving 10000 or 700), the 'ladder' governor usually yielded roughly 4000
wakeups per second. And, after starting and stopping X server (which
from some weird reason blocks C3 state even after terminating) I was
getting numbers below 300 wakeups/sec.

  Moreover, I previously ignored one fact, which might (or might not) be
related. Sometimes (quite rarely) the system crashes early on boot with
following message ("screenshot"):

http://image.dayphorum.eu/show/img-mhPMoxVfDZ.jpg

  I have no idea whether this is somehow related or not, anyway, the
boot doesn't continue. Unfortunately, VESA modes don't seem to work
properly (black screen), so I'm not able to get more than is visible on
the photo. Screenshot is from 2.6.26 kernel, but it has also happened on
2.6.27-rc3.

> 
> Thanks,
> Venki

  Thank you,
	Milan

