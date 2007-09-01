Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbXIAKOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbXIAKOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXIAKOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:14:11 -0400
Received: from mx1.suse.de ([195.135.220.2]:55555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXIAKOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:14:10 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Date: Sat, 1 Sep 2007 12:11:52 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070830174311.221133000@amd.com> <20070830174311.536394000@amd.com>
In-Reply-To: <20070830174311.536394000@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011211.52167.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 19:43:14 Robert Richter wrote:
> This patch implements PCI extended configuration space access for
> AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
> addresses. An x86 capability bit has been introduced that is set for
> CPUs supporting PCI extended config space accesses.

We shouldn't need this because extended config space should work
here and Linux should use it 
(especially after we added the ugly Barcelona workaround into  that code) 

The only exception would be if the user disables MMCONFIG in CONFIG, but that's
their own fault then.

Ok there might be buggy BIOS around with no or no usable MCFG table, but since
extended config space is not really a critical feature that's not a big issue.

So I don't think we want this special case code at all and should
just rely on MMCONFIG.

-Andi

