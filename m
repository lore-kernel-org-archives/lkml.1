Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbYBKRCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbYBKRCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYBKRCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:02:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbYBKRCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:02:00 -0500
Message-ID: <47B07F74.6010801@redhat.com>
Date: Mon, 11 Feb 2008 12:01:40 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] firewire: fw-sbp2: add INQUIRY delay workaround
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.b8a4817b51d0c9c9@s5r6.in-berlin.de>
In-Reply-To: <tkrat.b8a4817b51d0c9c9@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Several different SBP-2 bridges accept a login early while the IDE
> device is still powering up.  They are therefore unable to respond to
> SCSI INQUIRY immediately, and the SCSI core has to retry the INQUIRY.
> One of these retries is typically successful, and all is well.
> 
> But in case of Momobay FX-3A, the INQUIRY retries tend to fail entirely.
> This can usually be avoided by waiting a little while after login before
> letting the SCSI core send the INQUIRY.  The old sbp2 driver handles
> this more gracefully for as yet unknown reasons (perhaps because it
> waits for fetch agent resets to complete, unlike fw-sbp2 which quickly
> proceeds after requesting the agent reset).  Therefore the workaround is
> not as much necessary for sbp2.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Looks reasonable to me. I'm guessing there are some other devices out 
there that may well benefit from this (once added to the workarounds 
table, of course). Interesting that this is an encore appearance for a 
DViCO Momobay device...

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com

