Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZA3BEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZA3BEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZA3BER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:04:17 -0500
Received: from pandora.dialogue.co.uk ([82.115.230.200]:20297 "EHLO
	PANDORA.dialogue.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZA3BER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:04:17 -0500
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2009 20:04:16 EST
Message-ID: <49824E77.7010706@dialogue.co.uk>
Date: Fri, 30 Jan 2009 00:48:55 +0000
From: Andrew Basterfield <andrew@dialogue.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Jan Kara <jack@suse.cz>
Subject: Copying file with bad utf byte sequence in filename to rw UDF filesystem
 panics
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Jan 2009 00:51:07.0484 (UTC) FILETIME=[D5FEE9C0:01C98274]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Binary package hint: linux-image-2.6.24-22-generic

I have a file on ext3 that has a spurious 0x8A char in it's filename.
When I try to copy it to a R/W UDF volume I get a kernel panic.

$ ls Air\ -\ Le\ Soleil\ Est\ Pr�s\ De\ Moi.mp3 | hexdump -C
00000000  41 69 72 20 2d 20 4c 65  20 53 6f 6c 65 69 6c 20  |Air - Le Soleil |
00000010  45 73 74 20 50 72 8a 73  20 44 65 20 4d 6f 69 2e  |Est Pr.s De Moi.|
00000020  6d 70 33 0a                                       |mp3.|
00000024

The filesystem has to be mounted with iocharset=utf8

Is this related to http://lkml.org/lkml/2008/1/30/483

thanks

Andrew Basterfield

