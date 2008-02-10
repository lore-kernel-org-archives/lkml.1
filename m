Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYBJShe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYBJShe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYBJShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:37:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYBJShX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:37:23 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 11/9 update] firewire: fw-sbp2: enforce a retry of __scsi_add_device if bus generation changed
Date: Sun, 10 Feb 2008 13:36:57 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <47ACB449.3060200@s5r6.in-berlin.de> <tkrat.e02d667ba3320993@s5r6.in-berlin.de>
In-Reply-To: <tkrat.e02d667ba3320993@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802101336.57689.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008 04:33:29 pm Stefan Richter wrote:
> fw-sbp2 is unable to reconnect while performing __scsi_add_device
> because there is only a single workqueue thread context available for
> both at the moment.  This should be fixed eventually.
>
> An actual failure of __scsi_add_device is easy to handle, but an
> incomplete execution of __scsi_add_device with an sdev returned would
> remain undetected and leave the SBP-2 target unusable.
>
> Therefore we use a workaround:  If there was a bus reset during
> __scsi_add_device (i.e. during the SCSI probe), we remove the new sdev
> immediately, log out, and attempt login and SCSI probe again.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Now *this* does the trick. I get the 'READ CAPACITY failed' as before, 
then 'firewire_sbp2: fw1.0: error status: 0:4', followed by a new login and 
SCSI probe, both of which are successful this time, disk is available for use 
and all that good stuff.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com
