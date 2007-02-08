Return-Path: <linux-kernel-owner+w=401wt.eu-S1423303AbXBHUTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423303AbXBHUTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423306AbXBHUTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:19:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40674
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423303AbXBHUTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:19:46 -0500
Date: Thu, 08 Feb 2007 12:19:45 -0800 (PST)
Message-Id: <20070208.121945.102574093.davem@davemloft.net>
To: wcohen@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Size of 2.6.20 task_struct on x86_64 machines
From: David Miller <davem@davemloft.net>
In-Reply-To: <45CB4C55.4070902@redhat.com>
References: <45CB4C55.4070902@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Cohen <wcohen@redhat.com>
Date: Thu, 08 Feb 2007 11:14:13 -0500

> This past week I was playing around with that pahole tool
> (http://oops.ghostprotocols.net:81/acme/dwarves/) and looking at the
> size of various struct in the kernel. I was surprised by the size of
> the task_struct on x86_64, approaching 4K.  I looked through the
> fields in task_struct and found that a number of them were declared as
> "unsigned long" rather than "unsigned int" despite them appearing okay
> as 32-bit sized fields. On x86_64 "unsigned long" ends up being 8
> bytes in size and forces 8 byte alignment. Is there a reason there
> a reason they are "unsigned long"?

I think at one point we used the atomic bit operations to operate on
things like tsk->flags, and those interfaces require unsigned long as
the type.

That doesn't appear to be the case any longer, so at a minimum
your tsk->flags conversion to unsigned int should be ok.
