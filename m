Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbYBET1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbYBET1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759723AbYBET1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:27:34 -0500
Received: from mail.microway.com ([64.80.227.22]:40917 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759938AbYBET1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:27:32 -0500
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 14:27:32 EST
From: Rick Warner <rick@microway.com>
Organization: Microway, Inc.
To: linux-kernel@vger.kernel.org
Subject: serial port regression caused by "Char: tty_ioctl, use wait_event_interruptible_timeout" patch
Date: Tue, 5 Feb 2008 14:02:26 -0500
User-Agent: KMail/1.9.7
Message-Id: <200802051402.26816.rick@microway.com>
X-Sanitizer: Advosys mail filter
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

My company uses a proprietary hardware monitoring solution that utilizes 
communication over the serial port.  A RS232-RS485 converter is plugged into 
the serial port of the master of a cluster, and cat5 cables are daisy chained 
between the cards to handle out of band hardware monitoring.  The cards 
themselves speak RS485.  We have been using the same software to read the 
data from the serial port since the 2.4 kernel days.   As of 2.6.23, the 
software no longer works.

I narrowed down the problem doing a binary search on git snapshots between .22 
and .23, and found the breakage between git6 and git7.  Further isolating it 
found the patch mentioned in the subject to be the cause.  I reversed the 
patch in the .23 source and it now works properly.

Should the code be reverted back as I did, or is there something I should 
change in our userspace code that reads from the serial port to correct it 
instead?

Thanks,
Rick

-- 
Richard Warner
Lead Systems Integrator
Microway, Inc
(508)732-5517
