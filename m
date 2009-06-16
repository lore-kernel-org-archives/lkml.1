Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZFPTPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZFPTPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZFPTPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:15:02 -0400
Received: from main.gmane.org ([80.91.229.2]:35987 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbZFPTPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:15:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jason Lynch <jason@calindora.com>
Subject: [BUG?,FEATURE?] One core idles with 4 nice and 1 regular process
Date: Tue, 16 Jun 2009 19:09:59 +0000 (UTC)
Message-ID: <h18qm7$bf$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 207-118-117-152.dyn.centurytel.net
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, a description of the problem, and a fairly simple way to test it:

All of this is running on my quad-core Q6600. First, I start four nice -n 
19 processes, each of which does nothing but busy-wait. (In my case, I 
used a simple python script, but any CPU-bound process will do.) At this 
point, top shows all four cores being utilized, at approximately 100% 
nice each.

At this point, I start another of these busy-waiting processes, except 
with no nice adjustment, so it runs at regular priority. After doing so, 
top now reports the following CPU usage: one core is 100% user, two cores 
are 100% nice, and finally, one last core is 100% idle, doing nothing, 
despite a total of five processes being available to run.

I thought I first noticed this running a 2.6.29 kernel, and thought about 
bisecting, but my test 2.6.28 kernel also exhibited the behavior. I 
couldn't test any previous kernels due to a lack of ext4 support. Both my 
current 2.6.30 kernel and the torvalds/linux-2.6.git HEAD also show the 
behavior.

Now, I'm not sure if this is a bug or a strange feature (though it seems 
very bug-like to me) or perhaps a configuration problem, but I'd like to 
find out nonetheless.

If I can provide any additional information to help, I'll be happy to 
oblige.

