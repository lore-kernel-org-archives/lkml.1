Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbYAYRRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbYAYRRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYAYRRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:17:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbYAYRRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:17:04 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/4 update] firewire: fw-core: react on bus resets while the config ROM is being fetched
Date: Fri, 25 Jan 2008 12:16:35 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de> <4798E664.2040405@redhat.com> <tkrat.34be174a07a7f85e@s5r6.in-berlin.de>
In-Reply-To: <tkrat.34be174a07a7f85e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251216.35291.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 11:53:49 am Stefan Richter wrote:
> read_rom() obtained a fresh new fw_device.generation for each read
> transaction.  Hence it was able to continue reading in the middle of the
> ROM even if a bus reset happened.  However the device may have modified
> the ROM during the reset.  We would end up with a corrupt fetched ROM
> image then.
>
> Although all of this is quite unlikely, it is not impossible.
> Therefore we now restart reading the ROM if the bus generation changed.
>
> Note, the memory barrier in read_rom() is still necessary according to
> tests by Jarod Wilson, despite of the ->generation access being moved up
> in the call chain.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> First posted on 2007-11-01.  Update:  Barrier stays.

This is essentially what I've been beating on locally, and I've yet to hit 
another config rom read failure with it.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com
