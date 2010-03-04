Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab0CDF4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:56:14 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:53289 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab0CDF4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:56:12 -0500
Date: Thu, 04 Mar 2010 00:55:53 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [Resend][PATCH] ACPI / EC: Remove race between EC driver and
 suspend process (rev. 3)
In-reply-to: <201003040152.58437.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.1003040047310.1741@localhost.localdomain>
References: <201002272140.36891.rjw@sisk.pl>
 <alpine.LFD.2.00.1003031644410.1044@localhost.localdomain>
 <201003040152.58437.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't the problem at hand that the boot-kernel stops
in mid-transaction, and the resumed hibernate image
then blunders forward with its first transaction
only to find the EC in an intermediate state?

If yes, I then making the transaction atomic WRT
the boot kernel stopping should fix the problem.

The patch sets a FROZEN bit, and subsequent
requests for EC transactions simply fail.
How do we know that we set the bit at the right time?
What transactions or parts of transactions will fail,
and what are the consequences of those failures?

thanks,
Len Brown, Intel Open Source Technology Center

