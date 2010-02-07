Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0BGR24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 12:28:56 -0500
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:49564 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab0BGR2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 12:28:55 -0500
Date: Sun, 07 Feb 2010 12:28:51 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: x86 - cpu_relax - why nop vs. pause?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4B6EF853.9090704@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did search and noticed some old discussions. Looking at both Intel and 
AMD documentation, it would seem that PAUSE is the preferred instruction 
within a spin lock. Further, both Intel and AMD specifications state 
that the instruction is backward compatible with older x86 processors.

For fun, I changed nop to pause on my core i7 920 (smt enabled) and I'm 
seeing about a 5-10% performance improvement on 2.6.33 rc7. Perf top 
shows time spent in spin_lock under load drops from an average of around 
35% to about 25%.

Thoughts?
