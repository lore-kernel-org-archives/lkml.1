Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbYCFB6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbYCFB6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759115AbYCFB5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:57:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41784 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592AbYCFB5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:57:53 -0500
Date: Wed, 5 Mar 2008 17:55:13 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/9] Devices accessibility control group (v4)
Message-ID: <20080306015513.GA5359@kroah.com>
References: <47CED717.60406@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CED717.60406@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 08:23:35PM +0300, Pavel Emelyanov wrote:
> Changes from v3:
> * Ported on 2.6.25-rc3-mm1;
> * Re-splitted into smaller pieces;
> * Added more comments to tricky places.
> 
> This controller allows to tune the devices accessibility by tasks,
> i.e. grant full access for /dev/null, /dev/zero etc, grant read-only
> access to IDE devices and completely hide SCSI disks.

 From within the kernel itself?  The kernel should not be keeping track
of the mode of devices, that's what the filesystem holding /dev is for.
Those modes change all the time depending on the device plugged in, and
the user using the "console".  Why should the kernel need to worry about
any of this?

> Tasks still can call mknod to create device files, regardless of
> whether the particular device is visible or accessible, but they
> may not be able to open it later.
> 
> This one hides under CONFIG_CGROUP_DEVS option.
> 
> To play with it - run a standard procedure:
> 
>  # mount -t container none /cont/devs -o devices
>  # mkdir /cont/devs/0
>  # echo -n $$ > /cont/devs/0/tasks

What is /cont/ for?

> and tune device permissions.

How is this done?

Why would the kernel care about this stuff?

confused,

greg k-h
