Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbXGaQUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbXGaQUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764664AbXGaQUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:20:39 -0400
Received: from ns.suse.de ([195.135.220.2]:51739 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764072AbXGaQUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:20:37 -0400
From: Andreas Schwab <schwab@suse.de>
To: Greg KH <gregkh@suse.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Satyam Sharma <satyam@infradead.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci subsystem.
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
	<20070731125443.880871000@hawkeye.stone.uk.eu.org>
	<200707311553.29090.borntraeger@de.ibm.com>
	<alpine.LFD.0.999.0707311956170.26032@enigma.security.iitk.ac.in>
	<20070731144619.GA8183@localhost.localdomain>
	<20070731161051.GA7490@suse.de>
X-Yow: YOW!!  Everybody out of the GENETIC POOL!
Date: Tue, 31 Jul 2007 18:20:29 +0200
In-Reply-To: <20070731161051.GA7490@suse.de> (Greg KH's message of "Tue\, 31
	Jul 2007 09\:10\:51 -0700")
Message-ID: <jeir80y27m.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Tue, Jul 31, 2007 at 10:46:19PM +0800, WANG Cong wrote:
>> However, I think using resource_size_t is a bit better than unsigned long,
>> so that we don't need to check the defination of it.
>> 
>> - res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
>> + res->start = (resource_size_t)kmalloc(*size, GFP_KERNEL);
>> 
>> Is this change OK?
>
> Yes, that is the proper cast to have here.

It will generate a warning when resoure_size_t is 64bit on a 32bit arch.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
