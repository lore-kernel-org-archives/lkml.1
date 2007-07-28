Return-Path: <linux-kernel-owner+w=401wt.eu-S1762292AbXG1Lgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762292AbXG1Lgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 07:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXG1Lg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 07:36:27 -0400
Received: from ns.firmix.at ([62.141.48.66]:58853 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbXG1Lg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 07:36:26 -0400
Subject: Re: How to register block device as read-only
From: Bernd Petrovitsch <bernd@firmix.at>
To: beck0778@umn.edu
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Prayer.1.0.16.0707271307310.28071@wm1.tc.umn.edu>
References: <Prayer.1.0.16.0707271307310.28071@wm1.tc.umn.edu>
Content-Type: text/plain
Organization: http://www.firmix.at/
Date: Sat, 28 Jul 2007 13:36:14 +0200
Message-Id: <1185622574.3655.11.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.332 required=5
X-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 13:07 -0500, beck0778@umn.edu wrote:
> Hello,
> 
> In a block device driver, how do you tell the kernel that your block device 
> is read-only? Is it in the registration of the gendisk, or is there an 
> ioctl I should be catching to inform the kernel (and user) that this disk 
> is read-only?

Unless I misunderstand the question, the "write" and "writev" function
of the "struct file_operations" should return an appropriate error value
(which is here -EACCES).
You may think of returning an error in the "open" if someone wants to
open it to write to it (so that the must open it read-only).
But I don't know if that is common practice or not (or even disliked) as
it may interfere with not properly implemented tools which open devices
read-write even if they never write to it.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

