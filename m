Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYCVDNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYCVDNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYCVDNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:13:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYCVDNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:13:05 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: wait until PHY configuration packet was transmitted
Date: Fri, 21 Mar 2008 23:12:41 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <tkrat.47c2348a94015e02@s5r6.in-berlin.de>
In-Reply-To: <tkrat.47c2348a94015e02@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803212312.41277.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2008 06:48:23 pm Stefan Richter wrote:
> We now exit fw_send_phy_config /after/ the PHY config packet has been
> transmitted, instead of before.  A subsequent fw_core_initiate_bus_reset
> will therefore not overlap with the transmission.  This is meant to make
> the send PHY config packet + reset bus routine more deterministic.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Will double-check Monday that this solves never-ending (until panic) bus 
resets with a jmicron controller in the office, but this does indeed prevent 
a very similar looking case with a via vt6307 ohci 1.0 controller + iogear 
hub + unibrain fire-i camera:

  http://bugzilla.kernel.org/show_bug.cgi?id=10128

Wondering if this will be the ticket for nForce2 controllers as well. Still 
trying to track one down to poke at myself, although we can probably find 
someone out there to test. Also wondering how we hold up against a bus reset 
storm initiated by another host, thinking maybe we can still trigger the 
list_add corruption in that bug, but stopping the endless bus reset loops is 
definitely an improvement.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
