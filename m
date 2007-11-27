Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbXK0OnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbXK0OnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 09:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbXK0OnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 09:43:16 -0500
Received: from ns1.suse.de ([195.135.220.2]:52965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbXK0OnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 09:43:15 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Date: Tue, 27 Nov 2007 15:43:11 +0100
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Neil Horman <nhorman@redhat.com>, hbabu@us.ibm.com, vgoyal@in.ibm.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <200711271445.56792.ak@suse.de> <20071127142826.GB31376@hmsreliant.think-freely.org>
In-Reply-To: <20071127142826.GB31376@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271543.11809.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> As for solution 2, that brings me to my previous question.  Is that really as
> simple as just not moving the apic to legacy mode?  It would seem some
> additional programming would be in order to route the interrupt in question to
> the proper cpu.

The Linux kernel right now relies on being in legacy mode at bootup.
So obviously kexec has to switch back to that.

Not relying on legacy mode would require moving APIC setup much earlier which
is difficult because that's quite fragile. Longer term it might be a good
idea though anyways -- at least the timer code was always fragile
and eliminating one failure case and only ever running it in true
APIC mode would be probably a good thing.

-Andi

