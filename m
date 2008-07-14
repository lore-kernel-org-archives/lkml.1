Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbYGSKXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbYGSKXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYGSKWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:22:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:51434 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbYGSKWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:22:21 -0400
Message-ID: <487B5230.8040903@kernel.org>
Date: Mon, 14 Jul 2008 22:18:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Piter PUNK <piterpunk@slackware.com>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot
References: <Pine.LNX.4.63.0806141945270.2761@bob.slackware.com> <487B403F.5040704@gmail.com>
In-Reply-To: <487B403F.5040704@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Jul 2008 10:21:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> And the AHCI controller 1039:1185 @ 00:05.0 works just fine with
> regular devices and PMPs.  Can you please post lspci -nn output on
> your machine?  It seems the blacklisting was too wide.

Tested a bit more and the problem doesn't seem to be PMP support itself.
 Command issue doesn't work properly if follow up SRST is issued without
clearing SError after issuing hardreset.  2.6.26 always clears SError
after hardreset so it should work.  Piter, can you please remove SIS
blacklist and test 2.6.26?

Thanks.

-- 
tejun
