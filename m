Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZIPCT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZIPCT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZIPCTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:19:23 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49414 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850AbZIPCTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:19:22 -0400
X-Sasl-enc: PBF6P8kOJu+8Cxi9dr2D1xZsuVYMwqGLU4jFwAhTjsly 1253067565
Date: Tue, 15 Sep 2009 23:19:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       Linux USB <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: Using EV_MSC or extending KEY_*
Message-ID: <20090916021922.GA1627@khazad-dum.debian.net>
References: <aac07123ee2b14a0ac25d1652dbe0780.squirrel@intranet.cs.nmsu.edu>
 <5d5443650909151011k4b21a6d0n28ac6142c3d7161d@mail.gmail.com>
 <20090915183406.GA5696@core.coreip.homeip.net>
 <0debc76f26fe85e28adf642396233928.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0debc76f26fe85e28adf642396233928.squirrel@intranet.cs.nmsu.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, Rick L. Vinyard, Jr. wrote:
> As I understand it the EV_MSC/MSC_SCAN is used to trigger a prompting of
> the user to map a key, which would be useful for the G1-G22 keys and
> perhaps 5 of the 10 special keys. But, that's not the behavior I want for
> the M1, M2, M3, MR and backlight keys.

Why?

> Somehow they need to be distinct from any existing KEY_* codes or not have
> a code at all... i.e. only emitting the raw misc events.

Use KEY_RESERVED for them and in your driver, special case it to not output
EV_KEY events for KEY_RESERVED, but still output the EV_MSC/MSC_SCAN.

This allows userspace to reprogram them to normal keys (or even to
KEY_UNKNOWN) if it wants.

> Perhaps the BTN_MISC codes are better suited for these keys?

That could work too, but are these generic buttons?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
