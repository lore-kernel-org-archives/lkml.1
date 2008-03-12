Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbYCLRqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbYCLRqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYCLRqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:46:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:57180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYCLRqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:46:11 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Dave Jones <davej@codemonkey.org.uk>, linux-acpi@vger.kernel.org,
       Adam M Belay <abelay@mit.edu>
Subject: Re: PNP: increase the maximum number of resources
Date: Wed, 12 Mar 2008 13:45:20 -0400
User-Agent: KMail/1.9.9
Cc: Zhao Yakui <yakui.zhao@intel.com>, Li Shaohua <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Renninger <trenn@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080312151452.GA4523@codemonkey.org.uk>
In-Reply-To: <20080312151452.GA4523@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121345.21297.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Dave Jones wrote:
> In commit a7839e960675b549f06209d18283d5cee2ce9261 the number of PNP resources
> was increased.  In testing, we've found that the 'exceeded' warnings still get
> hit with quite high frequency. See https://bugzilla.redhat.com/show_bug.cgi?id=436589

In 2.6.23 we had:

#define PNP_MAX_PORT            8
#define PNP_MAX_MEM             4

And the kernel silently ignored a BIOS exceeding these limits

In 2.6.24 we have:

#define PNP_MAX_PORT            40
#define PNP_MAX_MEM             12

And the kernel complains with KERN_ERR when a BIOS has more resources
than the kernel can describe within these limits.

We know that there are cases where these static limits will be exceeded
but refrained from making these numbers larger due to concern about data structure size
and expectation that the majory of systems will fit within these limits.
(eg. there was one box with about 96 IO resources)

I agree that having a KERN_ERR that you know is going to fire is not a good situation.
We can either delete or KERN_DEBUG the message if it causes support issues --
for we know that <= 2.6.23 did worse by being silent.

Thomas worked on a patch to make resource allocation dynamic and do away
with these limits.  Unfortunately it was rather large and it wasn't in
time for the 2.6.25-rc1 window.  So right now we are on a trajectory
for 2.6.25 to behave exactly like 2.6.24.
Indeed, I don't think that patch made it into the test tree,
so unless we revive that patch, it will miss 2.6.26 as well.

thanks,
-Len
