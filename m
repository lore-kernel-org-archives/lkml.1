Return-Path: <linux-kernel-owner+w=401wt.eu-S936850AbXHLRSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936850AbXHLRSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbXHLRSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:18:08 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:57145 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760563AbXHLRSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:18:07 -0400
X-Greylist: delayed 2985 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Aug 2007 13:18:07 EDT
Date: Sun, 12 Aug 2007 18:28:20 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Subject: splice question
Message-ID: <20070812162820.GA26892@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently toying with splice. The test program I have sends a MPEG2 
transport stream from a dvb card and sends it to N clients via http.

Since the dvb frontend driver doesn't support splice 
(linux/drivers/media/dvb/dvb-core/dmxdev.c I guess, anyone interested in 
adding splice support to it?) I had to do a normal read() to a 
user-space buffer and then write that to a pipe.

Once the data is in the pipe, my idea was to tee() from the pipe to each 
client socket using nonblocking ops, and then consume the data by 
splicing it to /dev/null.

The problem is that tee() doesn't support sockets. Is this a limitation 
that would be easy to fix?

Otherwise I guess I'd have to add a second pipe, then (in a loop)
tee() from the first to the second pipe and then splice from the 
second pipe to a socket. Doesn't sound very elegant and would need quite 
a lot of extra syscalls.

-- 
David Härdeman
