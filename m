Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYE3LQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYE3LQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYE3LQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:16:47 -0400
Received: from dbservice.com ([213.239.204.14]:36253 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753027AbYE3LQq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:16:46 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 07:16:45 EDT
Message-ID: <20080530130739.25bz9mdjwwo080cw@dbservice.com>
Date: Fri, 30 May 2008 13:07:39 +0200
From: tom@dbservice.com
To: Holger Macht <hmacht@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
References: <20080528143857.GB5585@homac.suse.de>
In-Reply-To: <20080528143857.GB5585@homac.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-MailScanner-ID: 9AD8A20BB9C1.9229E
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.44, required 5, ALL_TRUSTED -1.44)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Holger Macht <hmacht@suse.de>:

> * Differentiate between bay devices in dock stations and others:
>
>  - When an ACPI_NOTIFY_EJECT_REQUEST appears, just signal uevent to
>    userspace (that is when the optional eject button on a bay device is
>    pressed/pulled) giving the possibility to unmount file systems and to
>    clean up. Also, only send uevent in case we get an EJECT_REQUEST
>    without doing anything else. In other cases, you'll get an add/remove
>    event because libata attaches/detaches the device.
>
>  - In case of a dock event, which in turn signals an
>    ACPI_NOTIFY_EJECT_REQUEST, immediately detach the device, because it
>    may already have been gone
>
> * In case of an ACPI_NOTIFY_DEVICE/BUS_CHECK, evaluate _STA to check if
>   the device has been plugged or unplugged. If plugged, hotplug it, if
>   unplugged, just signal event to userspace
>   (initial patch by Matthew Garrett <mjg59@srcf.ucam.org>)
>
> * Call ACPI _EJ0 for detached devices

Will this patch or the other bay/dock related patches you send in the  
past days allow me to undock my laptop and still be able to  
suspend/resume without locking the laptop up? And without having to  
run any userspace scripts?

My dock is not a simple port replicator, it has an USB hub and an ATA  
bay in it. My tests showed that I need to 'echo 1 >  
/sys/.../scsi/.../eject' or something like that before I can take the  
laptop out of the docking station. If I don't do that and try to  
access the cdrom in the bay (or even rescaning the scsi bus) after I  
have taken the laptop out of the dock it results in a hard lockup.  
That in itself would not be a problem, because it's just a simple  
command that I can do in an acpid script. But far worse is that even  
if I do that, the computer locks up when I resume from suspend. I run  
2.6.24.7 which locks up every time I resume. In recent versions from  
git it has somehow improved, there are situations where it doesn't  
lock up, but there are still a few left where it does (I don't  
remember the exact actions/commands I have to take).

tom


