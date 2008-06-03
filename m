Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYFCSHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYFCSHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYFCSHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:07:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47689 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbYFCSHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:07:45 -0400
Message-ID: <4845886E.2010505@garzik.org>
Date: Tue, 03 Jun 2008 14:07:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
References: <20080528143857.GB5585@homac.suse.de>
In-Reply-To: <20080528143857.GB5585@homac.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holger Macht wrote:
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
> 
> Signed-off-by: Holger Macht <hmacht@suse.de>
> ---
> 
> Changes regarding the previous patch:
> 
>  * Make sure kobj does not go away outside locking
>  * Coding style cleanups
>  * Call _EJ0 for detached devices

Matthew, any comments?

It would be nice if you and Holger could work together to produce a 
single patch[set]...  right now I have patches from both of you, and I 
was sorta waiting on the thread to die down to see if competing patches 
might merge into a single set

