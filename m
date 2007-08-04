Return-Path: <linux-kernel-owner+w=401wt.eu-S932728AbXHDVUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbXHDVUo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 17:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762141AbXHDVUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 17:20:35 -0400
Received: from antonio.urjc.es ([193.147.184.24]:39663 "EHLO antonio.urjc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762000AbXHDVUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 17:20:35 -0400
Message-ID: <46B4EDB1.1070808@urjc.es>
Date: Sat, 04 Aug 2007 23:20:49 +0200
From: Javier Pello <javier.pello@urjc.es>
Organization: Universidad Rey Juan Carlos
User-Agent: Thunderbird 2.0.0.0 (X11/20070503)
MIME-Version: 1.0
To: david@lang.hm
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
References: <46B37CF7.2020803@urjc.es>  
		<Pine.LNX.4.64.0708032219230.6905@asgard.lang.hm><46B43DBA.5040703@urjc.es
	> <Pine.LNX.4.64.0708041007430.6905@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0708041007430.6905@asgard.lang.hm>
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by 
	milter-greylist-2.0.2 (antonio.urjc.es [193.147.184.24]); Sat, 04 Aug 2007 
	23:20:15 +0200 (CEST)
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-7.4294 TC:1F TRN:31 TV:3.6.1039(15340.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007, David Lang wrote:
> what I've been told is that with the drive built-in instead of
> modular you can create a filesystem that has only the firmware
> on it, nothing else, and have the kernel find and load it (no
> userspace software involved)

I'm afraid my understanding of the kernel is not very deep, so
I don't know of this method you're describing.

Anyway, if there's no userspace involved then nothing should
change. The patch I sent only affects the behaviour of the kernel
when it actually tries to send a firmware request to userspace
(and it determines that the request was not received). If the
kernel loads a firmware image without userspace support, it must
do so in a codepath different from request_firmware, whose point
is precisely to send a firmware request and wait for it, and
request_firmware is the only function that effectively changes
with my patch.

Javier


