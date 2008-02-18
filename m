Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYBRUg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYBRUg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYBRUgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:36:19 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4653 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751078AbYBRUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:36:18 -0500
Date: Mon, 18 Feb 2008 15:36:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: Status of storage autosuspend
In-Reply-To: <20080218202749.GA2656@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0802181530330.31135-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Pavel Machek wrote:

> Hi!
> 
> What is the status of USB storage/SCSI autosuspend patches? They work
> nicely here ;-).

I could submit them, but there is one outstanding problem I would like
to solve first.  Maybe you can suggest a solution.

The problem is how to handle SG_IOCTL calls.  It seems that the only
safe thing to do is to force an autoresume and prevent the device from
autosuspending until the device file is closed.  Unfortunately the
SG_IOCTL stuff is all handled inside the block layer, and there's no
apparent way (other than some dreadful hack) of passing the necessary
information down to the SCSI layer.

Should we ignore this issue and submit the patches anyway?

Alan Stern

