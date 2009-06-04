Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZFDRVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZFDRVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZFDRVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:21:37 -0400
Received: from electron.quantumfyre.co.uk ([87.106.55.16]:45734 "EHLO
	electron.quantumfyre.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbZFDRVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:21:37 -0400
X-Greylist: delayed 1840 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 13:21:36 EDT
Date: Thu, 4 Jun 2009 17:48:29 +0100 (BST)
From: Julian Phillips <julian@quantumfyre.co.uk>
X-X-Sender: jp3@reaper.quantumfyre.co.uk
To: linux-kernel@vger.kernel.org
Subject: A question about using a private anonymous mmap
Message-ID: <alpine.LNX.2.00.0906041740110.21303@reaper.quantumfyre.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a program which creates a reasonably large private anonymous map. 
The program then writes into a few places in the map, but ends up reading 
from all of them.

When I run this program on a system running 2.6.20.7 the process only ever 
seems to use enough memory to hold the data that has actually been written 
(well - in units of PAGE_SIZE).  When I run the program on a system 
running 2.6.24.5 then as it reads the map the amount of memory used 
continues to increase until the complete map has actually been allocated 
(and since the total size is greater than the physically available RAM 
causes swapping).  Basically I seem to be seeing copy-on-read instead of 
copy-on-write type behaviour.

Is this an expected change, and is there any option I can tweak to get the 
old behaviour back?

TIA,

-- 
Julian

  ---
I can't die until the government finds a safe place to bury my liver.
 		-- Phil Harris
