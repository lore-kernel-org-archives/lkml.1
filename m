Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYA2Gp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYA2Gp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYA2Gpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:45:50 -0500
Received: from ns2.suse.de ([195.135.220.15]:60300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYA2Gpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:45:50 -0500
Date: Mon, 28 Jan 2008 22:44:15 -0800
From: Greg KH <gregkh@suse.de>
To: Michael E Brown <Michael_E_Brown@dell.com>
Cc: Jos?? Luis Tall??n <jltallon@adv-solutions.net>, Douglas_Warzecha@dell.com,
       Abhay_Salunke@dell.com, linux-kernel@vger.kernel.org,
       matt_domsch@dell.com, marcel@holtmann.org
Subject: Re: 2.6.24 breaks BIOS updates on all Dell machines
Message-ID: <20080129064415.GA8822@suse.de>
References: <20080129063244.GA19076@humbolt.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129063244.GA19076@humbolt.us.dell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 12:32:44AM -0600, Michael E Brown wrote:
> BIOS updates are broken on all Dell systems due to Commit
> 109f0e93b6b728f03c1eb4af02bc25d71b646c59, which is now in 2.6.24.
> 
>   static inline void fw_setup_device_id(struct device *f_dev, struct
> device *dev)
>   {
> -       /* XXX warning we should watch out for name collisions */
> -       strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
> +       snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s",
> dev->bus_id);
>  }
> 
> Two programs are broken by this change: 
>     1) dellBiosUpdate, which is part of libsmbios
>     2) All of the Dell Update Packages (DUPs) that are part of Dell
> OpenManage: each BIOS release for each of 3-4 dozen platforms.
> 
> These programs are broken due to the pathname change from
> /sys/class/firmware/dell_rbu/   to
> /sys/class/firmware/firmware-dell_rbu/loading. 
> 
> Realistically, I can fix libsmbios in a couple of weeks, but there is no
> way that we can go back and fix a couple hundred DUP packages for this
> change. If this stays, we are looking at over 6 months before we have an
> officially-available Dell OpenManage that can deal with it, and that
> would be for new BIOS releases only, I suspect.
> 
> Some of the relevant threads from when this was submitted and accepted:
> http://lkml.org/lkml/2005/5/23/73
> http://lkml.org/lkml/2005/5/23/62
> 
> Due to the extremely large and disruptive nature of this bug, it would
> be nice to get a 2.6.24.1 with this patch reverted.
> 
> I have copied the relevant developers at Dell who maintain this driver.
> Please preserve the cc: list when replying.

Fair enough, I have no problem reverting this.

Anyone want to keep it in?

thanks,

greg k-h
