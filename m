Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYAFWbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYAFWbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYAFWbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:31:33 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2432 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755523AbYAFWbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:31:32 -0500
Date: Sun, 6 Jan 2008 17:31:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801062324.15960.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801061729080.19222-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008, Rafael J. Wysocki wrote:

> Still, our present approach doesn't seem to be correct overall.  For example,
> I think we should prevent a suspend from happening while a device is being
> removed.

We could, however I don't think it's dangerous to allow it.  The two
problems to avoid are (1) messing up the PM device list pointers, and
(2) calling a driver's suspend/resume methods while its remove method
is running.  (1) is handled by the pm_list_mutex and (2) is handled by
locking dev->sem.

Alan Stern

