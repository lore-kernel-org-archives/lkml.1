Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbXLWOsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbXLWOsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXLWOsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:48:03 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:8756 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbXLWOsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:48:01 -0500
Date: Sun, 23 Dec 2007 15:47:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, rherilier@yahoo.fr,
       dtor@mail.ru
Subject: wistron_btns-add-support-for-x86_64-systems.patch in -mm
Message-ID: <20071223144756.GA4827@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 Dec 2007 14:41:54.0499 (UTC) FILETIME=[F63EC930:01C84571]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While looking for something else I stumbled over

wistron_btns-add-support-for-x86_64-systems.patch

in -mm. The patch looks very dubious to me. It basically
calls a BIOS function in long mode. To work like implemented
the BIOS would need to know magically what it was called
from (32bit or 64bit) and then execute different code paths.

It's very unlikely that this works. Most likely 
it will crash and if it happens to currently work 
it will be extremly fragile and crash at some future
point.

If anything you would need to set up a compat mode segment
and call the BIOS from that, but there are other problems
like interrupts not working etc (compat mode is somewhat
limited). Early in the x86-64 port there was a decision
to not call any BIOS calls from long mode because of these
problems. 

The only sane way to call that code would be to do so
from user space using some kind of emulator (e.g. like
the x server does) 

So I think the patch should be dropped.

-Andi

