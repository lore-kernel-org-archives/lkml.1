Return-Path: <linux-kernel-owner+w=401wt.eu-S1765421AbXF2HJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765421AbXF2HJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbXF2HJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:09:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:33156 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXF2HJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:09:07 -0400
Subject: Tasklet usage in the DRM
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Organization: Tungsten Graphics
Date: Fri, 29 Jun 2007 09:09:02 +0200
Message-Id: <1183100942.3289.296.camel@thor.sulgenrain.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I just read an article on LWN's kernel page about plans to remove
tasklets, and I thought I'd explain what the DRM is using tasklets for.
Maybe there's other ways to satisfy the requirements equally well or
even better.


The i915 driver uses a tasklet to make sure a GL buffer swap blit or
flip takes effect (or at least starts in the case of a blit) during the
vertical blank period, to avoid tearing. I chose a tasklet for this
purpose because:

      * The traditional method of the vertical blank interrupt waking up
        the user process, which would then emit the buffer swap
        commands, didn't even come close to avoiding tearing. So I
        suspect a workqueue wouldn't cut it either.
      * The processing of scheduled buffer swaps could potentially take
        a long time, so doing it in hardirq context could cause high IRQ
        latency.
      * It requires holding the DRM lock, so the 'each tasklet can only
        run once at a time' restriction is fine.


I'm looking forward to any suggestions what to do with this in case
tasklets disappear, and I'll gladly provide further clarification on the
requirements.


-- 
Earthling Michel Dänzer           |          http://tungstengraphics.com
Libre software enthusiast         |          Debian, X and DRI developer

