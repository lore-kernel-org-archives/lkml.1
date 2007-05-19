Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbXESTYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbXESTYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbXESTYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:24:44 -0400
Received: from gw1a.telemetry-investments.com ([64.20.161.180]:54660 "EHLO
	sv1.telemetry-investments.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755016AbXESTYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:24:43 -0400
X-Greylist: delayed 1762 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 15:24:43 EDT
Date: Sat, 19 May 2007 14:55:14 -0400
From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Nitin Gupta <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
Message-ID: <20070519185514.GA17869@ti88.telemetry-investments.com>
Mail-Followup-To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Nitin Gupta <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
	Richard Purdie <richard@openedhand.com>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com> <m3646pg7fy.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3646pg7fy.fsf@maximus.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 11:14:57PM +0200, Krzysztof Halasa wrote:
> I'm certainly missing something but what are the advantages of this
> code (over current gzip etc.), and what will be using it?

Richard's patchset added it to the crypto library and wired it into
the JFFS2 file system.  We recently started using LZO in a userland UDP
proxy to do stateless per-packet payload compression over a WAN link.
With ~1000 octet packets, our particular data stream sees 60% compression
with zlib, and 50% compression with (mini-)LZO, but LZO runs at ~5.6x
the speed of zlib.  IIRC, that translates into > 700Mbps on the input
side on a 2GHZ Opteron, without any further tuning.

Once LZO is in the kernel, I'd like to see it wired into IPComp.
Unfortunately, last I checked only the "deflate" algorithm had an
assigned compression parameter index (CPI), so one will have to use a
private index until an official one is assigned.

Regards,

	Bill Rugolsky
