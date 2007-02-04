Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbXBDRR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbXBDRR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXBDRR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:17:59 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:56214 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbXBDRR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:17:59 -0500
Message-ID: <45C61540.7000008@drzeus.cx>
Date: Sun, 04 Feb 2007 18:17:52 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Petr Vandrovec <vandrove@vc.cvut.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz> <45B7D750.1040501@drzeus.cx> <45B868D5.9070409@vc.cvut.cz> <45B8845E.8070008@drzeus.cx> <45C57695.7000707@vc.cvut.cz>
In-Reply-To: <45C57695.7000707@vc.cvut.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Vandrovec wrote:
>
> Problem is with these pointers - reply_buf & server->packet.  Now code
> will just read packet from server->packet, and write result to
> reply_buf, most probably transmiting some random data to network, and
> overwriting innocent memory on receiption...  I believe that you need
> to make copies of server->packet/size for transmission, and some
> simillar solution for receive as well.  As both request & response can
> be up to ~66000 bytes.

Hmm.. I thought server->packet was protected until the packet was
completed, independent of the process that issued it. Looking closer I
see that this isn't quite the case.

How about this... We allocate two buffers at startup, one for outgoing
and one for incoming. Then we use these during the actual transmission,
copying back and forth as need. Then we just need to avoid the final
response copy if the process has gone belly up.

Now my next question in that case is, what is the purpose of
server->packet. Couldn't this buffer be provided by the caller like the
response buffer?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

