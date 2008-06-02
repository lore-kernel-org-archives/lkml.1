Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYFBXa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYFBXa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYFBXaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:30:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbYFBXap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:30:45 -0400
Date: Mon, 2 Jun 2008 16:30:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, carlos@strangeworlds.co.uk
Subject: Re: RESEND: [PATCH 3/3] Misc: Add HP WMI laptop extras driver
Message-Id: <20080602163037.a7044f68.akpm@linux-foundation.org>
In-Reply-To: <20080529082356.GE16444@srcf.ucam.org>
References: <20080528132152.GB32646@srcf.ucam.org>
	<20080528132900.GC32646@srcf.ucam.org>
	<20080529082356.GE16444@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 09:23:56 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> This driver adds support for reading and configuring certain information 
> on modern HP laptops with WMI BIOS interfaces. It supports enabling and 
> disabling the ambient light sensor, querying attached displays and hard 
> drive temperature, sending events on docking and querying the state of 
> the dock and toggling the state of the wifi, bluetooth and wwan hardware 
> via rfkill. It also makes the little "(i)" button work on machines that 
> send that via WMI rather than via the keyboard controller.

I should upgrade everyone to checkpatch-0.19...

WARNING: consider using strict_strtoul in preference to simple_strtoul
#300: FILE: drivers/misc/hp-wmi.c:244:
+       u32 tmp = simple_strtoul(buf, NULL, 10);

The reason for this is that simple_strtoul(() will treat "42foo" as
valid input (ie: 42).  Whereas strict_strtoul() will report an error,
which is neater of us.


