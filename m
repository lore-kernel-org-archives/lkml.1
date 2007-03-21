Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbXCUCR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbXCUCR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 22:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXCUCR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 22:17:27 -0400
Received: from animx.eu.org ([216.98.75.249]:36672 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbXCUCR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 22:17:26 -0400
Date: Tue, 20 Mar 2007 22:15:56 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Philippe Troin <phil@fifi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: scsi: Devices offlined
Message-ID: <20070321021556.GA5039@animx.eu.org>
Mail-Followup-To: Philippe Troin <phil@fifi.org>,
	linux-kernel@vger.kernel.org
References: <20070321004830.GA4901@animx.eu.org> <87ircv5q33.fsf@tantale.fifi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ircv5q33.fsf@tantale.fifi.org>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe Troin wrote:
> Wakko Warner <wakko@animx.eu.org> writes:
> 
> > [84797.683873] sr 1:0:13:0: scsi: Device offlined - not ready after error recovery
> > 
> > Is there anyway to make the kernel "online" a device that has done this? 
> > I've had this happen on various devices (mostly on usb where I can
> > unplug/replug), but this time, it's on a scsi controller and the driver is
> > not a module.
> > 
> > If it's possible to do this w/o rebooting, I'd like to know for when I have
> > this happen in the future.
> 
> Have you tried:
> 
>   echo remove-single-device BUS ID LUN > /proc/scsi
>   echo add-single-device BUS ID LUN > /proc/scsi

I tried:
echo "scsi remove-scingle-device 1 0 13 0" > /proc/scsi/scsi
<device removed from /proc/scsi/scsi list>
echo "scsi add-scingle-device 1 0 13 0" > /proc/scsi/scsi
<device does not show up in /proc/scsi/scsi list>

I also tried your method, which just gives invalid argument (using
/proc/scsi/scsi, since /proc/scsi is a directory)

According to scsi_proc.c:
        /*
         * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
         * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
         */

        /*
         * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
         * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
         */

Either way, nothing.

Er, on second though, I actually unplugged the power from the scsi device
and replugged it and it shows up now.  Oh well..  Thanks anyway =)

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
