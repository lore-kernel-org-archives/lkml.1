Return-Path: <linux-kernel-owner+w=401wt.eu-S1760985AbZAMXmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760985AbZAMXmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZAMXlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:41:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:45610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760650AbZAMXlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:41:04 -0500
Date: Tue, 13 Jan 2009 15:36:20 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: driver creating directories under a device entry
Message-ID: <20090113233620.GA17949@suse.de>
References: <20090113232734.GS12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113232734.GS12431@fluff.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:27:34PM +0000, Ben Dooks wrote:
> I have a driver which uses sysfs_create_dir() to create a set of
> directories under the device sysfs directory to bundle up attributes
> that are added common for each sub-part of the device.
> 
> Firstly, is this considered a problem

Yes and no.

> Secondly, sysfs_create_dir() is not exported so the driver cannot
> currently be built as a module. Would a patch to export sysfs_create_dir
> be acceptable?

No :)

The problem is, you are probably creating these attributes _after_
userspace has been notified that the device is present, right?  So that
causes a not-so-nice race.

To do this properly, use an attribute group, name it (that will cause it
to show up in a subdirectory), attach it to the device, and then it will
be created automatically when the device is registered with the driver
core, at the proper time to then notify userspace that the device, and
all of its attributes, are present.

Does this help?

thanks,

greg k-h
