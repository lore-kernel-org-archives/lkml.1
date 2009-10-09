Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbZJIQpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbZJIQpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761122AbZJIQpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:45:20 -0400
Received: from james.oetiker.ch ([213.144.138.195]:33415 "EHLO
	james.oetiker.ch" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752404AbZJIQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:45:19 -0400
Date: Fri, 9 Oct 2009 18:44:12 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: linux-kernel@vger.kernel.org
Subject: Linux IO service time - a perfect source of randomness ?
Message-ID: <alpine.DEB.2.00.0910091814470.14413@sebohet.brgvxre.pu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have just completed extensive benchmarking of ext3 on 2.6.31.2
both on HW RAID6 as well as single Hard Drive. I have written a new
file system benchmark that creates load by reading and writing large
file trees in paralle to simulate a busy fileserver.

The results are as follows:

 * as soon as the system comes under strain the service time
   for single io operations becomes almost random with huge
   outliers of several seconds.

 * on HW RAID the best performance is to be gained with
   data=ordered and cfq scheduler

 * on single HDD setups, only (!) data=writeback with cfq provides
   good performance.

 * the deadline scheduler did not perform well in any of the
   read/write scenarios.

 * btrfs has fantastic read performance but does not (yet?) do well
   when readers and writers are competing.

my report is on

  http://insights.oetiker.ch/linux/fsopbench/

cheers
tobi

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
