Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbYBAV02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbYBAV02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYBAV0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:26:21 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20635 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633AbYBAV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:26:20 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [build bug] undefined reference to `i2c_attach_client'
X-Message-Flag: Warning: May contain useful information
References: <20080201120945.GA14632@elte.hu> <20080201135836.GA20294@elte.hu>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 01 Feb 2008 13:26:18 -0800
In-Reply-To: <20080201135836.GA20294@elte.hu> (Ingo Molnar's message of "Fri, 1 Feb 2008 14:58:36 +0100")
Message-ID: <aday7a4jrlx.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Feb 2008 21:26:18.0795 (UTC) FILETIME=[156A87B0:01C86519]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > randconfig testing found the following build bug in latest -git:
 > > 
 > >  drivers/built-in.o: In function `v4l2_i2c_attach':
 > >  : undefined reference to `i2c_attach_client'

I hit this too -- it seems that commit 8ffbc655 ("V4L/DVB (6451):
v4l2: add support for bus-based I2C drivers"), which added
v4l2_i2c_attach() without adding any dependency on CONFIG_I2C.  Not
sure what the correct fix is -- either CONFIG_VIDEO_DEV needs to
select/depend on CONFIG_I2C, or v4l2_i2c_attach() should only be built
if CONFIG_I2C is on.
