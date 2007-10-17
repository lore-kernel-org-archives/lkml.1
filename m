Return-Path: <linux-kernel-owner+w=401wt.eu-S934426AbXJQUnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426AbXJQUnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbXJQUm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:42:58 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34116 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757036AbXJQUm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:42:57 -0400
X-Sasl-enc: VKsQNOExNrKAvtZ5QYqOQH9H+wKPp7LQe8LiAEbXk0xX 1192653774
Date: Wed, 17 Oct 2007 18:42:50 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071017204250.GA13377@khazad-dum.debian.net>
References: <20071016144016.GA21749@srcf.ucam.org> <20071016165623.GA13643@khazad-dum.debian.net> <20071016184606.GB25181@srcf.ucam.org> <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org> <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com> <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org> <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com> <20071017162827.GA9778@srcf.ucam.org> <20071017173532.GB2974@khazad-dum.debian.net> <d120d5000710171159p617115d9w862aadf266c2470c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000710171159p617115d9w862aadf266c2470c@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Dmitry Torokhov wrote:
> > The use of the same path for notifications and events are already a big
> > enough concession to the HAL model.  AFAIK, HAL is the only reason why on
> > most systems the userspace consumer of events and notification events are
> > the same.  HAL gets them all (as well as ACPI events, and whatever else its
> > helpers poll the system for), and then distributes them over to various
> > other paths.
> 
> I have a nagging feeling that we rely on HAL and windows environments
> too much nowadays. Last night I tried to susped my laptop while at KDM
> prompt but apparently some service is only running in context of user
> session and so nothing was there to recognize that suspend button was
> pressed (Fedora 8).

Hrnf, you are not the only one.

> That was not my primary goal. We have bitmaps of supported events in
> input_dev structure. If we were to reuse KEY_* constants for EV_NOTIFY
> then I have to make this bitmap the same size as input_dev->keybit,
> which is 512 bit at the moment (and I am thinking that we do need to
> extend it to 1024). I expect that we need much less KEY_*_NOTIFY
> events so that we could easily fit them into 32 bits.

This would be a good reason to limit what can be a notification event, yes,
since it will increase the size of every input device.

> > I'd rather we added an EV_NOTIFY *bit* that gets or-ed to the real EV_*
> > type, so that one can turn any event into a notification.  This is certainly
> > to be useful at least for EV_KEY and EV_SWITCH.
> 
> The problem with this scenario is that userspace can never be sure if
> input device is capable of only KEY_BLAH, only KEY_BLAH_NOTIFY or
> both. Normally we let userspace query device for all supported events.

Everything capable of EV_foo would be able to issue EV_foo notifications.
While this is not optimal, it is probably good enough.  Still, I was
thinking about it, and a doubt came to mind: would it cause problems for a
bitmap to share the function for EV_foo and EV_foo notifications?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
