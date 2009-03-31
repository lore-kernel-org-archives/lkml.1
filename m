Return-Path: <linux-kernel-owner+w=401wt.eu-S1764147AbZCaXC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764147AbZCaXC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763360AbZCaXCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:02:10 -0400
Received: from fmailhost01.isp.att.net ([207.115.11.51]:36565 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871AbZCaXCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:02:09 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49D2A0BF.2090901@lwfinger.net>
Date: Tue, 31 Mar 2009 18:01:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] kaweth: Fix locking to be SMP-safe
References: <49d264dd.YwbXLw18YaD1tQqD%Larry.Finger@lwfinger.net> <200903312350.38658.oliver@neukum.org>
In-Reply-To: <200903312350.38658.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Dienstag 31 März 2009 20:45:49 schrieb Larry Finger:
>> On an SMP system, the following message is printed. The patch below gets
>> fixes the problem.
> 
> Are you sure it is never called with disabled interrupts?

I think not, but all I really know is that the change from spin_lock() to
spin_lock_irq() makes the errors go away.

I checked a number of drivers to see what their ndo_start_xmit routines do. Most
use spin_lock_irq(), but some do no locking.

I tried removing the locking, but that resulted in a stall even when I bypassed
the faulty router.

Larry
