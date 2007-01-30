Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbXA3KYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbXA3KYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbXA3KYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:24:00 -0500
Received: from highlandsun.propagation.net ([66.221.212.168]:4247 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbXA3KX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:23:59 -0500
X-Greylist: delayed 1240 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 05:23:59 EST
Message-ID: <45BF1CBE.4040201@symas.com>
Date: Tue, 30 Jan 2007 02:23:58 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9a2pre) Gecko/20070128 Netscape/7.2 (ax) Firefox/1.5 SeaMonkey/1.5a
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why active list and inactive list?
References: <7Gpmk-5fN-21@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijls...@chello.nl> said:
> I'm still torn between CLOCK-Pro and CART. 
> 
> CLOCK-Pro is still vulnerable to the cyclic scan use case, since at that
> time all pages will have equal distance.

I was recently testing CLOCK-Pro for the entry cache in OpenLDAP, with this 
cyclic scan case. I've set it aside for now, but if anyone is interested in 
playing with a user-level version as opposed to these kernel adaptations, an 
early version of mine is at
http://www.openldap.org/its/index.cgi/Software%20Enhancements?id=4807

I found that although it managed to allow some cached pages to be reused, it 
also forced several full sweeps of the clock in each scan. Overall it 
performed more slowly than regular CLOCK due to these extra sweeps. (In our 
case, moving the hands required some expensive lock manipulation. Possibly if 
I found a better locking strategy there the performance cost would come down.)

-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc
   OpenLDAP Core Team            http://www.openldap.org/project/
