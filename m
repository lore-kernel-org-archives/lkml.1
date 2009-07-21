Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZGUDx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZGUDx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZGUDxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:53:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42598 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbZGUDxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:53:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A653B9B.4020501@jp.fujitsu.com>
Date: Tue, 21 Jul 2009 12:52:59 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, norsk5@yahoo.com,
       aris@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC PATCH 0/14] amd64_edac: marry mcheck to amd64 edac
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Clearly, the "Run through mcelog... " line is redundant now :) since
> there's no need for userspace decoding anymore and the original EDAC
> functionality (polling workqueue) is still preserved. The code currently
> uses EDAC to decode DRAM ECC errors but this could clearly be extended
> to handle all valid addresses acquired from MCi_ADDR registers.

Then how about having:

static default_decode_mce(struct mce *m)
{
	printk(KERN_EMERG "Run through mcelog ... "
}

void (*decode_mce)(struct mce *m) = default_decode_mce;

and replace the pointer by edac_decode_mce() or so?


Thanks,
H.Seto

