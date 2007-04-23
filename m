Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbXDWWUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbXDWWUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbXDWWUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:20:23 -0400
Received: from pool-72-92-185-191.albyny.east.verizon.net ([72.92.185.191]:50858
	"EHLO posidon.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754333AbXDWWUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:20:22 -0400
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2007 18:20:22 EDT
Message-ID: <462D2B4E.7050009@tmr.com>
Date: Mon, 23 Apr 2007 17:55:26 -0400
From: Bill Davidsen <davidsen@tmr.com>
Reply-To: davidsen@posidon.tmr.com
Organization: TMR Associates, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: [RFC] another scheduler beater
Content-Type: multipart/mixed;
 boundary="------------040507030003050305020700"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040507030003050305020700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The small attached script does a nice job of showing animation glitches 
in the glxgears animation. I have run one set of tests, and will have 
several more tomorrow. I'm off to a poker game, and would like to let 
people draw their own conclusions.

Based on just this script as load I would say renice on X isn't a good 
thing. Based on one small test, I would say that renice of X in 
conjunction with heavy disk i/o and a single fast scrolling xterm (think 
kernel compile) seems to slow the raid6 thread measurably. Results late 
tomorrow, it will be an early and long day :-(

--------------040507030003050305020700
Content-Type: application/x-sh;
 name="glitch1.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="glitch1.sh"

# look for glitches in scheduling

# xterm scroll option
#   -j - do jump scroll
#   +j - do one line scroll
# if SCROLL is specified that's used instead
scroll=${SCROLL:-"+j"}

for n in 1 2 3 4; do
  vpos=$[(n-1)*80+50]
  xterm -geom 100x2-0+${vpos} ${scroll} -e bash -c "while true; do echo \$RANDOM; done" &
done

uname -r >gl_impr.tmp

vmstat 1 >gl_vmstat.tmp &

glxgears


--------------040507030003050305020700--
