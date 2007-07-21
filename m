Return-Path: <linux-kernel-owner+w=401wt.eu-S934525AbXGUIjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525AbXGUIjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbXGUIjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:39:36 -0400
Received: from phoenix.clifford.at ([88.198.7.52]:51914 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbXGUIjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:39:35 -0400
Date: Sat, 21 Jul 2007 10:42:33 +0200
From: Clifford Wolf <clifford@clifford.at>
To: Shannon Nelson <shannon.nelson@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: DMA Engine vs. DMA Transfer API
Message-ID: <20070721084233.GE21334@clifford.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shannon, hi lkml,

I'm writing a driver for the built-in DMA controller of the Freescale
MPC8349E PowerPC based microcontroller. Unfortunately the DMA-Engine
API seams to be the totally wrong thing for that since this DMA controller
has many features which are not available thru dmaengine afaics, such as:

 * Scatter-Gather on source and/or destination
 * Fifo modes for 8-, 16- and 32-bit (on source and dest)
 * Snooping mode, Multiple direct PCI read modes, ...

Also this DMA controller has only 4 channels (I do not know how many
channels I/OAT has). So I needed a spooling subsystem so many drivers
can easily share the available dma channels. The api also supports
more than one backend device and automatically finds out which backend
device fits a dma request best. I've named the entire thing dmatransfer
api. A current devel snapshot can be found at:

	http://www.clifford.at/priv/dmatransfer-20070711.diff

(I am on vacation right now and don't have access to my test hardware. So
the entire thing is 'frozen' right now until the second august week when
I'm back in the office.)

The smart infrasturcture adds some overhead: In a testcase copying 1GB of
data from memory to memory in 64kB chunks (300MHz DDR SDRAM, 500MHz PowerPC
CPU) this overhead is about 0.25% over controlling the dma controller
directly without my framework.

Afaics there is only one user of DMA Engine framework right now and only
one driver: The network stack.

any chances that we can migrate I/OAT to my more flexible DMA Engine
framework and modify the network stack to use dmatransfer instead of
dmaengine or in any other way integrate the APIs?

yours,
 - clifford

-- 
"In the future, airplanes will be flown by a dog and a pilot. And the
dog's job will be to make sure that if the pilot tries to touch any of
the buttons, the dog bites him." - Scott Adams (author of Dilbert).
