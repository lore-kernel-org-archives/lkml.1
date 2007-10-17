Return-Path: <linux-kernel-owner+w=401wt.eu-S935985AbXJQRfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935985AbXJQRfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbXJQRfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:35:42 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46627 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190AbXJQRfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:35:41 -0400
X-Sasl-enc: Q4R+FskNlxN+ccfQnspVDsBWtwbh+E9VBewLv+rDpiB7 1192642536
Date: Wed, 17 Oct 2007 15:35:32 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071017173532.GB2974@khazad-dum.debian.net>
References: <20071016142121.GA21431@srcf.ucam.org> <20071016143124.GB3237@khazad-dum.debian.net> <20071016144016.GA21749@srcf.ucam.org> <20071016165623.GA13643@khazad-dum.debian.net> <20071016184606.GB25181@srcf.ucam.org> <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org> <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com> <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org> <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com> <20071017162827.GA9778@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017162827.GA9778@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Matthew Garrett wrote:
> On Wed, Oct 17, 2007 at 11:57:18AM -0400, Dmitry Torokhov wrote:
> > say that they only care about notifications arising from keypresses
> > then I will add EV_NOTIFY type of events to input layer. What events
> > would we need? I can imagine:
> 
> Why use EV_NOTIFY? They're still keys. I'd also quibble with the need 

Why not?  Why the heck do we have to keep the worst of the current mess,
when many drivers CAN (and sometimes have to) tell appart the two classes of
events?  Make notifications a separate thing from regular events, please.

The use of the same path for notifications and events are already a big
enough concession to the HAL model.  AFAIK, HAL is the only reason why on
most systems the userspace consumer of events and notification events are
the same.  HAL gets them all (as well as ACPI events, and whatever else its
helpers poll the system for), and then distributes them over to various
other paths.

On a HAL-less system, it is far less clear that anything that needs the real
events would bother with the notifications.  The only class of applications
that have an use for the notifications are OSD applets and the like.

> for adding _NOTIFY varients of already existing keys - the existing 
> consumers can all cope already.

If one adds EV_NOTIFY, one can just allow for the same KEY constants that
are valid for EV_KEY, and be done with that, I suppose.  But my take is that
Dmitry wants to limit the number of notifications going over input.

I'd rather we added an EV_NOTIFY *bit* that gets or-ed to the real EV_*
type, so that one can turn any event into a notification.  This is certainly
to be useful at least for EV_KEY and EV_SWITCH.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
