Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbZIQR5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbZIQR5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbZIQR5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:57:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48993 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbZIQR5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:57:07 -0400
X-Sasl-enc: K9RPhVZfPxcp8TmorvL2icycIGbxPQsnJ3hlk2wzvQ6d 1253210230
Date: Thu, 17 Sep 2009 14:57:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       Linux USB <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: Using EV_MSC or extending KEY_*
Message-ID: <20090917175707.GB789@khazad-dum.debian.net>
References: <aac07123ee2b14a0ac25d1652dbe0780.squirrel@intranet.cs.nmsu.edu>
 <5d5443650909151011k4b21a6d0n28ac6142c3d7161d@mail.gmail.com>
 <20090915183406.GA5696@core.coreip.homeip.net>
 <0debc76f26fe85e28adf642396233928.squirrel@intranet.cs.nmsu.edu>
 <20090916034642.GC2756@core.coreip.homeip.net>
 <2c0ac825ebe78da99328b896faae04a2.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0ac825ebe78da99328b896faae04a2.squirrel@intranet.cs.nmsu.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Rick L. Vinyard, Jr. wrote:
> The M* keys are intended to provide a quick way to switch between key
> mappings, with each mode having their own user-defined mappings.

What I'd do in this case would be this:

1. Initially have the M* level-shift keys assigned KEY_RESERVED

2. Have a big enough keymap to map all keys in all M*-level shift states
possible.

Eg:
   START OF KEYMAP
   M* keys
   1st set of G* keys
   2nd set of G* keys
   3rd set of G* keys...
   ...
   last set of G* keys
   END OF KEYMAP

3. Have the driver special-process M* level-shift keys *as long as they are
still set to KEY_RESERVED* to select which part of the keymap is used to
translate the other keys.  Note that this likely means pressing a M* key
would be transparent to userspace in this case, i.e. no events would be
issued when a M* key is doing a level shift.

So, you'd be able to set all mappings you want in the driver, and the M*
keys would do what they're expected to do without any userland help at all,
but you'd still be able to program the M* keys to be normal keys if you
want.

Of course, this assumes you don't do chording on multiple M* keys to end up
with a huge number of keymaps :p

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
