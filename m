Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbYB1OE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbYB1OE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYB1OEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:04:14 -0500
Received: from gw.c1.byte.nl ([82.94.214.64]:43271 "EHLO smtp.byte.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752512AbYB1OEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:04:14 -0500
Date: Thu, 28 Feb 2008 15:04:12 +0100 (CET)
From: Allard Hoeve <allard@byte.nl>
Reply-To: Allard Hoeve <allard@byte.nl>
To: linux-kernel@vger.kernel.org
Subject: Scheduler lockup or nfsd problem in 2.6.24.2 and 2.6.23.17?
Message-ID: <Pine.LNX.4.62.0802281452240.1709@office2.c1.internal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello all,

The last few days our trusty NFS server has experienced several soft 
lockups. These occur every 11 hours or so. The system does not respond 
afterwards. Sending sysrq commands over the serial console seems to work 
allthough we had to powercycle the server once.

First we thought it would be an NFS problem, and now that we tried 
2.6.23.17 instead of 2.6.24.2, we now have two different stacktraces that 
share a trace through nfsd (nfsd_direct_splice_actor):

http://article.gmane.org/gmane.linux.nfs/19107
http://article.gmane.org/gmane.linux.nfs/19130

The second however, leads me to think the (relatively new) scheduler might 
be involved through __check_preempt_curr_fair.

I'm now trying 2.6.22.19, which has a recent lockd issue with NFS fixed 
but hasn't had the scheduler update.

How do I go about debugging this problem? What do you experts think?

Regards,

Allard Hoeve

