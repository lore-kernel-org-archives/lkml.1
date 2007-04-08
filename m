Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbXDHTn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbXDHTn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXDHTn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:43:58 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:59514 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbXDHTn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:43:57 -0400
Message-ID: <46194692.3000601@drzeus.cx>
Date: Sun, 08 Apr 2007 21:46:26 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Weird MMC errors: 2 of 2 - inconsistent state after data crc
 error
References: <20070314150254.22941.qmail@web36714.mail.mud.yahoo.com>
In-Reply-To: <20070314150254.22941.qmail@web36714.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> Problem 2: After a data crc error all subsequent commands fail. May it be caused by stop command
> leaving card in some bad state (something clearable by SEND_STATUS)? On the other hand, is there a
> real need to issue a stop command in case main command failed?
> 

It might be, depending on what the problem is. E.g. timeout might still mean the
card processed the command and will start sending data.

Anyway, CRC errors should be extremely rare so I'd guess that either the card or
the controller has gotten confused. In many cases the card will shut down when
it gets annoyed, so that might be what you're seeing here.

Other than that, I'm not sure I can help that much. The stop commands should
never wedge the card, so that isn't the issue (unless the card is buggy).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
