Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbXKQMst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbXKQMst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 07:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbXKQMsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 07:48:39 -0500
Received: from simmts5-qfe0.srvr.bell.ca ([206.47.199.163]:55053 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbXKQMsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 07:48:38 -0500
From: Kevin Winchester <kjwinchester@gmail.com>
To: Andrew Morgan <morgan@kernel.org>
Subject: Re: 2.6.24-rc2-mm1 -- strange apparent network failures
Date: Sat, 17 Nov 2007 08:48:35 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       kamalesh@linux.vnet.ibm.com
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <20071115164441.67a8e2df.akpm@linux-foundation.org> <473E794A.4060107@kernel.org>
In-Reply-To: <473E794A.4060107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711170848.35726.kjwinchester@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On November 17, 2007 01:16:58 am Andrew Morgan wrote:
> Hi,
>
> This warning is just saying that you might want to reconsider
> recompiling your dhclient with a newer libcap - which has native support
> for 64-bit capabilities. This is supposed to be informative, and not be
> associated with any particular error.
>
> From your comments, you believe that this patch causes something in your
> boot process to fail. Can you supply some detail about the version of
> dhclient you are using? I'd like to understand exactly what it is doing
> (via libcap).
>
> Thanks
>

The boot succeeds (and appears to bring initialize the network adapter 
properly - it autonegotiates a 100Mbps link speed), but the dhcp client is 
never able to get an address.  However, applying the rc2-mm1 patch series up 
to just before:

  add-64-bit-capability-support-to-the-kernel.patch

results in a working kernel.  Applying just this patch causes the failure.  To 
be sure, I also tried applying the above patch plus the following ones:

  add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
  add-64-bit-capability-support-to-the-kernel-fix.patch
  add-64-bit-capability-support-to-the-kernel-fix-fix.patch
  remove-unnecessary-include-from-include-linux-capabilityh.patch

but the problem still occurs even with all of these.

As to versions, I'm running Kubuntu gutsy, so I have the default:

dhcp3-client           3.0.5-3ubuntu4
libcap1                1:1.10-14build1

packages installed.

Let me know if you need any other information, or if you have a patch you 
would like tested.

-- 
Kevin Winchester
