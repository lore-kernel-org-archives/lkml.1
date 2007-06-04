Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbXFDSFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbXFDSFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759823AbXFDSFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:05:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759764AbXFDSE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:04:58 -0400
From: Andi Kleen <ak@suse.de>
To: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Re: [PATCH] x86_64: remove check for CONSTANT_TSC from time.c
Date: Mon, 4 Jun 2007 20:02:40 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, "Joachim Deguara" <joachim.deguara@amd.com>,
       "Nagendra, Bhavana" <bhavana.nagendra@amd.com>
References: <20070604174926.GA22013@amd.com>
In-Reply-To: <20070604174926.GA22013@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706042002.41091.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 19:49, Joerg Roedel wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
>
> This patch removes the check for the CONSTANT_TSC cpu flag from time.c
> on the x86_64 architecture. At the time this flag is checked at boot the
> cpu init code was yet not executed and thus the check fails. At this
> point the check for VENDOR_AMD and cpu family 0x10 is sufficient.

Wrong fix. The bit just needs to be set earlier in early cpu detect. Otherwise 
there is a problem again with the next constant TSC AMD CPU.
I will do that.

-Andi
