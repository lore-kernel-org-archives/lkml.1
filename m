Return-Path: <linux-kernel-owner+w=401wt.eu-S1763366AbXFJT3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763366AbXFJT3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXFJT3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:29:38 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:52818
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756587AbXFJT3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:29:37 -0400
Message-ID: <466C5112.4090004@hawkeye.stone.uk.eu.org>
Date: Sun, 10 Jun 2007 20:29:22 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 0/7] Cleanup code to replace DPRINTK with pr_debug
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <20070610105024.b16d1708.randy.dunlap@oracle.com>
In-Reply-To: <20070610105024.b16d1708.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Hi,
> 
> Doesn't this move printk-debug control from local source files
> (i.e., targeted, specific ones) to a more global control (DEBUG)?
> 
> If so, I don't see that as a generally good thing.
> 
> If not, please correct me and tell me how this is useful to just
> one instance of using pr_debug() in say, ncpfs, without pr_debug()
> being enabled throughout the entire kernel tree.
> 
> Thanks.

I can certainly see that point but using pr_debug means that all the
debug print statements are centralised so that changes to the format
could be more uniform. For example, it would be very easy to change the
macro to print the function name it was called from followed by the message.

The only DPRINTK's with specific DEBUGs were alternative.c, which had an
extra if, and ncpfs which had an extra #ifdef DEBUG_NCP. The alternative
solution would be to change the #defines to use pr_debug rather than
printk directly:

#define DPRINTK(format, args...) \
	pr_debug(format, ##args);

The advantage would be maitaining subsystem specific debug control with
centralised format control.

Jack
