Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZFFWAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZFFWAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZFFWAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:00:12 -0400
Received: from wsip-70-184-212-11.om.om.cox.net ([70.184.212.11]:33845 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbZFFWAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:00:10 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Solution: N810 keyboard regression
Date: Sat, 6 Jun 2009 16:51:34 -0500
User-Agent: KMail/1.11.3 (Linux/2.6.27-gentoo-r7; KDE/4.2.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906061651.43882.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found the problem with the 2.6.29 N810 keyboard regression in this commit:
	commit c83702a764c3099df50f215b8e79e07344e34a1a
	Author: Felipe Balbi <felipe.balbi@nokia.com>
	Date:   Thu Feb 19 12:29:40 2009 +0000
	    input: lm8323: get rid of useless debug macro
	    we can use dev_vdbg() which is only true when VERBOSE is enabled.

Part of this commit removed the "default" values for platform parameters, but 
set the N810's size_y to 8 instead of the earlier default of 12. Changing this 
to 12 (patch to follow) fixes the keyboard regression. Note, the total keys on 
the N810 is in fact under 64, so 8x8 seems correct. Not sure why it doesn't 
work like that in practise. I did notice a curious line in the driver that 
might (or might not) be related/wrong...

drivers/input/keyboard/lm8323.c line 353:
	int keysize = (lm->size_x << 4) | lm->size_y;

Shouldn't this be lm->size_x * lm->size_y?

Luke
