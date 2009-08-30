Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZH3VGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZH3VGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 17:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZH3VGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 17:06:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZH3VGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 17:06:18 -0400
Message-ID: <4A9AE998.4040201@zytor.com>
Date: Sun, 30 Aug 2009 14:05:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Avi Kivity <avi@qumranet.com>
Subject: The msr_safe functions and returning -EFAULT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, the *msr_safe() functions are returning -EFAULT.  As far as I
can tell, this makes absolutely no sense -- EFAULT is a nonsensical
error (it means a pointer into user memory given to a system call is
invalid), and the only user that seems to use this as anything other
than a boolean is the MSR driver, which wants EIO.

Sending out an email in case I have missed any instances, but I'm
inclined to just change this to EIO globally.

Anyone has objections?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

