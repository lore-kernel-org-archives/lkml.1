Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbXE0Ups@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbXE0Ups (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbXE0Upk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:45:40 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:54865 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbXE0Upk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:45:40 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <200705272231.54535.rjw@sisk.pl>
References: <200705272229.21263.rjw@sisk.pl> <200705272231.54535.rjw@sisk.pl>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6BD5252F-96CD-49D9-86C7-18115294D913@cam.ac.uk>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Sun, 27 May 2007 21:45:35 +0100
To: "Rafael J. Wysocki" <rjw@sisk.pl>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 May 2007, at 21:31, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Use a hibernation and suspend notifier to disable the firmware  
> requesting
> mechanism before a hibernation/suspend and enable it after the  
> operation.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>
>  drivers/base/firmware_class.c |   36 ++++++++++++++++++++++++++++++ 
> ++++++
>  1 file changed, 36 insertions(+)

I don't like this approach, as I feel that the firmware loading  
interface should be able to detect if a firmware load request is not  
being handled, due to absence of userspace / hotplug handler presence.

Other circumstances in which this can be a problem is during bootup  
when request_firmware() calls can be made before userspace is up and  
init has run (even in the presence of an initramfs).

(Slightly OT: A particularly nasty race is when an initramfs  
userspace is present, but firmware loading cannot occur because init  
has not run, so proc hasn't been mounted, so a hotplug event handler  
cannot be registered, despite the fact that the firmware is sitting  
on the ramdisk mounted correctly...)

In short, a more general solution would be preferred, and preferably  
one which allows firmware loading to *actually* occur once userspace  
has actually turned up and registered a handler :)

Michael-Luke Jones

