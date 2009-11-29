Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZK2V7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZK2V7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZK2V73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:59:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:1849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZK2V71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:59:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sm3a7CRaDkU9EwT9xo/qIbClutRY27bt2xZffMHKf9cST6+9HHtxk762Tpmop1BgJl
         riZc+qjBkM0YNB95V9jTU+6qNSpWJAdUlV+Og8EOjMLZH095A0E8A6nbe8TRF4xtv8Tw
         v5IHpL5QR/Oy1sN60Tz6+E35pyJFNcuQDP1uU=
Message-ID: <4B12EEC2.3030207@gmail.com>
Date: Sun, 29 Nov 2009 22:59:30 +0100
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Thunderbird 2.0.0.22pre (X11/20090422)
MIME-Version: 1.0
To: mike@mtgambier.net
CC: Jon Smirl <jonsmirl@gmail.com>,
       Christoph Bartelmus <christoph@bartelmus.de>, jarod@wilsonet.com,
       awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
       jarod@redhat.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com> <200911291317.03612.mike@mtgambier.net>
In-Reply-To: <200911291317.03612.mike@mtgambier.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Lampard wrote:
> an example I have a VDR instance running in the background on my desktop 
> machine outputting to a TV in another room via a pci mpeg decoder - I 
> certainly don't want the VDR remote control interacting with my X11 desktop in 
> any way unless I go out of my way to set it up to do so, nor do I want it 
> interacting with other applications (such as MPD piping music around the 
> house) that are controlled via other remotes in other rooms unless specified.
> 
> Setting this up with Lircd was easy, how would a kernel-based proposal handle 
> this?

eg

EV="/dev/input/"$( cd "/sys/class/input" &&
   ( grep -l 'X10' event*/device/name || grep -l 'X10' event*/device/manufacturer ) |
   sed -e 's,/.*,,' )

./vdr [...] -P "remote -i $EV"

This is how it has worked for years, so there's no reason it wouldn't work w/ any
future scheme. The remote buttons normally arrive as normal kbd keys; once an app
grabs the input device corresponding to a remote, it receives the events exclusively.

artur
