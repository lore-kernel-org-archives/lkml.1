Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419Ab0ARQKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0ARQKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391Ab0ARQKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:10:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41568 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754380Ab0ARQKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:10:19 -0500
Date: Mon, 18 Jan 2010 11:10:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH] PM / Runtime: Add sysfs switch for disabling device
 run-time PM
In-Reply-To: <201001180129.55219.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001181102460.6554-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Runtime: Add sysfs switch for disabling device run-time PM
> 
> Add new device sysfs attribute, power/runtime, allowing the user
> space to block the run-time power management of the device.  If this
> attribute is set to "disabled", the driver of the device won't be
> able to enable run-time power management for it (without breaking the
> rules).

Ouch.  This does nearly the same thing as the power/level attribute in
the USB subsystem, but in an incompatible and more complicated way.

The power/level attribute can contain either "on" or "auto", meaning
that the device is always on or that it is subject to automatic runtime
power management (autosuspend).  Changing the setting from "auto" to
"on" merely does sets a flag and does pm_runtime_get_sync(); changing
it from "on" to "auto" clears the flag and does pm_runtime_put_sync().

Is there any reason this same mechanism shouldn't be used for all
devices?

Alan Stern

