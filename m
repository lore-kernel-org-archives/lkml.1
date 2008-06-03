Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYFCTAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYFCTAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYFCTAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:00:45 -0400
Received: from www.linux-info-tag.de ([217.160.143.166]:4205 "EHLO
	p15139323.pureserver.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751311AbYFCTAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:00:45 -0400
X-Greylist: delayed 2403 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 15:00:45 EDT
Date: Tue, 3 Jun 2008 20:20:40 +0200
From: Christian Perle <chris@linuxinfotag.de>
To: linux-kernel@vger.kernel.org
Subject: "core dump helper" runs always as root
Message-ID: <20080603182040.GB20582@silmor.de>
Reply-To: chris@linuxinfotag.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Silmor
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi *

I recently played around with the /proc/sys/kernel/core_pattern file
(2.6.24.7 and 2.6.25) and found out that processes started by the
"|/path/to/executable" notation always run as root, even if the
segfaulting process runs as non-root.

Is there a reason for this behaviour? If not, i would suggest starting the
process which receives the core dump on stdin as the same UID of the
segfaulting process.

With the current behaviour you can do funny things:

(as root)
# echo "|/bin/chmod 4755 /bin/ash" > /proc/sys/kernel/core_pattern

(as user)
$ sleep 2 & kill -11 $!

Of course this is *not* a local root exploit because you need to be root
to write to the proc entry, but IMHO running the "core dump helper" (is
there a better name for this?) always as root is potentially harmful.


Greetings,
  Chris
-- 
Christian Perle                                    chris AT linuxinfotag.de
010111                                              http://chris.silmor.de/
101010                          LinuxGuitarKitesBicyclesBeerPizzaRaytracing
