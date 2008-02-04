Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYBDIMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYBDIMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 03:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYBDILw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 03:11:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34810 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYBDILv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 03:11:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47A6C8BF.30204@s5r6.in-berlin.de>
Date: Mon, 04 Feb 2008 09:11:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: fw-sbp2: wait for completion of fetch agent
 reset
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.f428e74c4b757abb@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f428e74c4b757abb@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Like the old sbp2 driver, wait for the write transaction to the
> AGENT_RESET to complete before proceeding (after login, after reconnect,
> or in SCSI error handling).
> 
> There is one occasion where AGENT_RESET is written to from atomic
> context when getting DEAD status for a command ORB.  There we still
> continue without waiting for the transaction to complete because this
> is more difficult to fix...

In addition, we need to serialize agent resets by the SCSI error handler
and the command ORB completion against ongoing reconnects/ relogins.
-- 
Stefan Richter
-=====-==--- --=- --=--
http://arcgraph.de/sr/
