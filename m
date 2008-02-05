Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbYBEQZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbYBEQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbYBEQZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:25:25 -0500
Received: from smtp-107-backup.nerim.net ([62.4.16.107]:51156 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758482AbYBEQZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:25:22 -0500
Date: Tue, 5 Feb 2008 17:25:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Michael E Brown <Michael_E_Brown@dell.com>
Cc: Markus Rechberger <markus.rechberger@amd.com>, Matt_Domsch@dell.com,
       Jos?? Luis Tall??n <jltallon@adv-solutions.net>,
       Douglas_Warzecha@dell.com, Abhay_Salunke@dell.com,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: 2.6.24 breaks BIOS updates on all Dell machines
Message-ID: <20080205172511.68116747@hyperion.delvare>
In-Reply-To: <20080204155834.GA32437@humbolt.us.dell.com>
References: <20080129064415.GA8822@suse.de>
	<479F3F60.8050108@amd.com>
	<20080129190417.GA15410@speedy.student.utwente.nl>
	<20080129190924.GB8786@humbolt.us.dell.com>
	<20080203150238.2e9c6704@hyperion.delvare>
	<20080204155834.GA32437@humbolt.us.dell.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 09:58:35 -0600, Michael E Brown wrote:
> On Sun, Feb 03, 2008 at 03:02:38PM +0100, Jean Delvare wrote:
> > Hi Michael,
> > 
> > On Tue, 29 Jan 2008 13:09:25 -0600, Michael E Brown wrote:
> > > On Tue, Jan 29, 2008 at 08:04:17PM +0100, Sytse Wielinga wrote:
> > > > I've created the simple patch below. I have no idea if it actually works,
> > > > though, as I don't appear to have any hardware for which a linux driver
> > > > supports firmware loading. Please comment.
> > > 
> > > You can test this rather easily. Simply modprobe the "dell_rbu" driver.
> > > You dont need any special hardware, it should load on any machine. After
> > > you have loaded it, check the sysfs path to see if it has the correct
> > > path (or some symlink thereof):
> > > 
> > > GOOD: /sys/class/firmware/dell_rbu/   
> > > BAD : /sys/class/firmware/firmware-dell_rbu/loading
> > 
> > This doesn't actually work for me. Loading the dell_rbu driver on a
> > non-Dell system doesn't create anything under /sys/class/firmware.
> 
> You have to initialize the driver first before that file appears.
> 
> [root@localhost ~]# modprobe dell_rbu
> [root@localhost ~]# cd /sys/devices/platform/dell_rbu/
> [root@localhost dell_rbu]# ll /sys/class/firmware/dell_rbu/loading 
> ls: cannot access /sys/class/firmware/dell_rbu/loading: No such file or
> directory
> [root@localhost dell_rbu]# echo -n -e 'init\0' > image_type 
> [root@localhost dell_rbu]# ll /sys/class/firmware/dell_rbu/loading 
> -rw-r--r-- 1 root root 4096 2008-02-04 09:57
> /sys/class/firmware/dell_rbu/loading

Ah, OK, thanks for the hint, it works now.

-- 
Jean Delvare
