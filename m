Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYA1WbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYA1WbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYA1WbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:31:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYA1WbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:31:08 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] firewire: fix "kobject_add failed for fw* with -EEXIST"
Date: Mon, 28 Jan 2008 17:30:47 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de> <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de>
In-Reply-To: <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281730.47575.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 12:20:40 pm Stefan Richter wrote:
> There is a race between shutdown and creation of devices:  fw-core may
> attempt to add a device with the same name of an already existing
> device.  http://bugzilla.kernel.org/show_bug.cgi?id=9828
>
> Impact of the bug:  Happens rarely, forces the user to unplug and replug
> the new device to get it working.
>
> The fix moves deregistration of the minor number and device_unregister()
> into a common rw_sem protected section.
>
> We also move the ref count increment from fw_device_op_open into an
> rw_sem protected section with the lookup of the device, so that the
> device pointer can't become invalid between lookup and usage.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

While I've got remaining issues with firewire mdraid, this does appear fix the 
problem of devices racing the grab the same fw* device node, and it seems 
obvious that should indeed be the case from the code changes.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
