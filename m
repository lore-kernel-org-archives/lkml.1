Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbZBRVF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbZBRVF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZBRVFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:05:51 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:14220 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbZBRVFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:05:50 -0500
From: Frans Pop <elendil@planet.nl>
To: jplatte@naasa.net
Subject: Re: cpuinfo shows wrong MHz value
Date: Wed, 18 Feb 2009 22:05:46 +0100
User-Agent: KMail/1.9.9
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <200902142217.51655.jplatte@naasa.net> <200902151741.30303.elendil@planet.nl> <200902182054.38840.jplatte@naasa.net>
In-Reply-To: <200902182054.38840.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182205.47737.elendil@planet.nl>
X-OriginalArrivalTime: 18 Feb 2009 21:05:48.0247 (UTC) FILETIME=[AC2A0E70:01C9920C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009, Joerg Platte wrote:
> The last kernel that was working correct was 2.6.24 (here the output
> from 2.6.24.6):

Right. I suspect then that the following commit may be the cause of the
regression:
commit ed9cbcd40004904dbe61ccc16d6106a7de38c998
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Nov 20 14:20:21 2007 -0500
    Revert "speedstep-lib.c: fix frequency multiplier for Pentium4 models 0&1"

That would exactly explain the factor 8 of the error.

Do you have a line like the following in your debug output?
    P4 - FSB %u kHz; Multiplier %u; Speed %u kHz\n
If so, what does it say for .24 and .28?

Can you please provide the output of 'x86info -a' (as root) after loading
the cpuid module?
