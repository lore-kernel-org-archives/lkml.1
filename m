Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYGLDFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYGLDFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 23:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYGLDE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 23:04:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1904 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752363AbYGLDE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 23:04:59 -0400
Date: Fri, 11 Jul 2008 23:04:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm 1/2] kexec jump -v12: kexec jump
In-Reply-To: <m1lk076dtj.fsf@frodo.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.0807112255450.9023-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008, Eric W. Biederman wrote:

> I just realized with a little care the block layer does have support for this,
> or something very close.
> 
> You setup a software raid mirror with one disk device.    The physical
> device can come in and out while the filesystems depend on the real device.

Do you mean "the filesystems depend on the logical RAID device"?  

What's to prevent userspace from accessing the physical device 
directly?

What this amounts to, in the end, is having a way to distinguish the
set of I/O requests coming from the hibernation code (reading or
writing the memory image) from the set of all other I/O requests.  The
driver or the block layer has to be set up to allow the first set
through while blocking the second set.  (And don't forget about the 
complications caused by error-recovery I/O during the hibernation 
activity!)

Forcing the second set of requests to filter through an extra software 
layer is a clumsy way of accomplishing this.  There ought to be a 
better approach.

Alan Stern

