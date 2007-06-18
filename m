Return-Path: <linux-kernel-owner+w=401wt.eu-S1765979AbXFRTAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765979AbXFRTAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764887AbXFRTAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:00:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20146 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762640AbXFRS77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:59:59 -0400
Date: Mon, 18 Jun 2007 12:01:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Quota netlink interface
Message-Id: <20070618120103.2807b78d.randy.dunlap@oracle.com>
In-Reply-To: <20070618121455.GI9319@duck.suse.cz>
References: <20070618121455.GI9319@duck.suse.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 14:14:55 +0200 Jan Kara wrote:

>   Hello,
> 
>   I've written a patch implementing quota netlink interface. Whenever some
> event happens (like user exceeding softlimit), a message is sent to
> userpace. Then, in userspace we can decide what to do with the message -
> print it to console, show a dialog or whatever... I've also written a new
> daemon that listens to netlink and sends the received message to DBus and/or
> to the console the user has last written to.
>   If somebody is interested in trying it out, he can checkout latest
> quota-tools CVS and I can provide him with the modified libnl providing
> better support for generic netlink handling.


+config QUOTA_NETLINK_INTERFACE
+	bool "Report quota messages through netlink interface"
+	depends on QUOTA
+	select NET
+	help
+	  If you say Y here, quota warnings (about exceeding softlimit, reaching
+	  hardlimit, etc.) will be reported through netlink interface. If unsure,
+	  say Y.


Using "select" is either evil or OK, but only OK for "library-type" code.
It should never be used to pull in a complete subsystem like NET does
(even though SCSI_NETLINK does this same thing, sadly).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
