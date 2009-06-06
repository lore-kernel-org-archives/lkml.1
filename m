Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZFFWoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZFFWoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZFFWoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:44:25 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40099 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZFFWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:44:25 -0400
Date: Sun, 7 Jun 2009 01:42:04 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Luke-Jr <luke@dashjr.org>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Solution: N810 keyboard regression
Message-ID: <20090606224204.GA16764@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <200906061651.43882.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906061651.43882.luke@dashjr.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 06 Jun 2009 22:44:10.0263 (UTC) FILETIME=[4EA73A70:01C9E6F8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 11:51:34PM +0200, ext Luke-Jr wrote:
> Found the problem with the 2.6.29 N810 keyboard regression in this commit:
> 	commit c83702a764c3099df50f215b8e79e07344e34a1a
> 	Author: Felipe Balbi <felipe.balbi@nokia.com>
> 	Date:   Thu Feb 19 12:29:40 2009 +0000
> 	    input: lm8323: get rid of useless debug macro
> 	    we can use dev_vdbg() which is only true when VERBOSE is enabled.
> 
> Part of this commit removed the "default" values for platform parameters, but 
> set the N810's size_y to 8 instead of the earlier default of 12. Changing this 
> to 12 (patch to follow) fixes the keyboard regression. Note, the total keys on 
> the N810 is in fact under 64, so 8x8 seems correct. Not sure why it doesn't 
> work like that in practise. I did notice a curious line in the driver that 
> might (or might not) be related/wrong...
> 
> drivers/input/keyboard/lm8323.c line 353:
> 	int keysize = (lm->size_x << 4) | lm->size_y;
> 
> Shouldn't this be lm->size_x * lm->size_y?

Are you sure that was the commit that changed it ?
that commit is only getting rid of the debug() macro and making use of
dev_vdbg().

If you had just followed git blame you'd see that was already the
default value on n810's lm8323 platform_data since the initial import of
that code into linux-omap.

I do recall testing my patches on n810 before sending them upstream and
they were working. How are you testing this ? which tree are you using ?
did you try changing that keysize calculation ? Do you see irqs comming?
Any debugging messages ?

-- 
balbi
