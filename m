Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZC3P72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZC3P72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZC3P7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:59:17 -0400
Received: from fmailhost04.isp.att.net ([207.115.11.54]:61156 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZC3P7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:59:16 -0400
X-Greylist: delayed 59241 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2009 11:59:16 EDT
X-Originating-IP: [69.76.240.125]
Message-ID: <49D0EC24.4080206@lwfinger.net>
Date: Mon, 30 Mar 2009 10:58:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] kaweth: Fix locking to be SMP-safe
References: <49d00512.XAF19LdpY1dlK6+U%Larry.Finger@lwfinger.net> <200903300828.45337.oliver@neukum.org>
In-Reply-To: <200903300828.45337.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Montag 30 März 2009 01:32:34 schrieb Larry Finger:
>> On an SMP system, the following message is printed. The patch below gets
>> fixes the problem.
> 
> Thanks for this report and the patch. I think, however that it introduces
> unneeded locking. It seems to me that we should be fine if we fix
> kaweth_start_xmit(). That code assumes that it is called with interrupts
> off and under a spinlock. Is that incorrect?

You are correct in that only the locking in kaweth_start_xmit() needs to be
changed to lock out the other CPU's. In my testing under extreme conditions (X
server over the network), the interface stalled with no logged messages. My
other changes in the locking were an unsuccessful attempt to fix that and have
been removed. Version 2 of the patches will be sent after I finish testing.

Thanks,

Larry


