Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0CIPOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:14:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34149 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751344Ab0CIPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:14:14 -0500
Date: Tue, 9 Mar 2010 10:14:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 4/6] usb-serial: optimize sysrq function calls
In-Reply-To: <1268116151-1448-5-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1003091008070.1693-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Jason Wessel wrote:

> There is no need to have external function calls for the sysrq
> functions.  The compiler can inline the sysrq calls such that they are
> entirely a NOP if CONFIG_MAGIC_SYSRQ is not set.

This is not the best way to do what you want.  Keep 
usb_serial_handle_sysrq_char() and usb_serial_handle_break() as 
out-of-line routines in generic.c, but make them conditional on 
CONFIG_MAGIC_SYSRQ.  Then in the header file, depending on whether or 
not CONFIG_MAGIC_SYSRQ is defined, either put the usual extern function 
declarations or else put do-nothing inline definitions.

The advantage of keeping the functions out-of-line is the reduced
amount of code space (since the bodies aren't replicated every place
they get used).  This way you keep that advantage while still getting
the NOP implementation if CONFIG_MAGIC_SYSRQ isn't set.

Alan Stern

