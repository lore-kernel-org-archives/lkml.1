Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbZFWQ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbZFWQ7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbZFWQ7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:59:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbZFWQ7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:59:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Introduce core framework for run-time PM of I/O devices (rev. 3)
Date: Tue, 23 Jun 2009 19:00:03 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Oliver Neukum <oliver@neukum.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>
References: <200906230121.18932.rjw@sisk.pl>
In-Reply-To: <200906230121.18932.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231900.04660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Rafael J. Wysocki wrote:
> Hi,
> 
> Below is a new revision of the patch introducing the run-time PM framework.
> 
> The most visible changes from the last version:
> 
> * I realized that if child_count is atomic, we can drop the parent locking from
>   all of the functions, so I did that.
> 
> * Introduced pm_runtime_put() that decrements the resume counter and queues
>   up an idle notification if the counter went down to 0 (and wasn't 0 previously).
>   Using asynchronous notification makes it possible to call pm_runtime_put()
>   from interrupt context, if necessary.
> 
> * Changed the meaning of the RPM_WAKE bit slightly (it is now also used for
>   disabling run-time PM for a device along with the resume counter).
> 
> Please let me know if I've overlooked anything. :-)

Well, I found quite a few problems myself, mostly related to disabling-enabling
of the run-time PM and to RPM_WAKE.

Updated patch will be sent out later today.

Best,
Rafael
