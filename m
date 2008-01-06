Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYAFCPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYAFCPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 21:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYAFCO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 21:14:59 -0500
Received: from mxsf00.insightbb.com ([74.128.0.70]:64147 "EHLO
	mxsf00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYAFCO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 21:14:58 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2008 21:14:58 EST
X-IronPort-AV: E=Sophos;i="4.24,249,1196658000"; 
   d="scan'208";a="170468257"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAGbFf0dKjlCP/2dsb2JhbACBV5AUlwk
X-IronPort-AV: E=Sophos;i="4.24,249,1196658000"; 
   d="scan'208";a="183531997"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: acpi/apm events as inputs: how to handle?
Date: Sat, 5 Jan 2008 21:05:02 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
References: <477B5FD8.5070503@msgid.tls.msk.ru>
In-Reply-To: <477B5FD8.5070503@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801052105.03068.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Wednesday 02 January 2008, Michael Tokarev wrote:
> What I'm thinking about is: why ACPI events are
> routed over input subsystem, instead of hotplug
> subsystem?  With input, there's a need for a
> special daemon/application listening on the
> specific "keyboard" device, while with hotplug
> subsystem, it's already here - linux (by default
> anyway, if not running udev etc), kernel fires
> up a script when an event occurs.  I don't see
> how this special application/daemon is different
> from ol'good acpid.

There are keyboards (USB, PS2) with Sleep and Suspend buttons
that are not related to ACPI nor APM. We had 2 options - add
an input handler that would translate input events into ACPI
events and feed /proc/acpi/event[*] or go other way around and
use input layer for delivering suspend and sleep requests for
all types of keyboards/buttons, including ACPI buttons. The
secons option is better because userspace solution using input
layer will not be tied to a particular technology (ACPI) and
can be used on other platforms as well.  
  
-- 
Dmitry

[*] Embedded people are not particularly interested in
processing suspend requests in userspace and would rather
do it right in the kernel. I am about to apply a patch
from Richard Purdie that adds transaltion from input events
into APM events.
