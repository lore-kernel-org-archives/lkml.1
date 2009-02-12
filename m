Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbZBLVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbZBLVIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZBLVIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:08:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34044 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZBLVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:08:06 -0500
Date: Thu, 12 Feb 2009 22:25:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [2/4] x86: MCE: Implement dynamic machine check banks support v5
Message-ID: <20090212212511.GB2486@one.firstfloor.org>
References: <20090212143.515129156@firstfloor.org> <20090212124321.8A98B3E666D@basil.firstfloor.org> <1234461785.4286.1918.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234461785.4286.1918.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do we need a per cpu count of # of banks to handle one CPU having less
> banks than others case?
> Specifically, I am thinking of sequence:
> - CPU 0 has n banks
> - CPU 0 does below
> 	for (i = 0; i < banks; i++) {
> 		err = sysdev_create_file(&per_cpu(device_mce, cpu),
> 					&bank_attrs[i]);
> - CPU 1, which comes online later, has say n-2 banks. So, banks now becomes n-2.
> - Now whenever CPU 0 does sysdev_remove_file loop below, it will do it only for n-2 banks.

True, that would be a leak without per cpu banks count. Perhaps should take 
it out, this is really not supposed to happen anyways. I'm sure
more things would break with an asymetric CPU configuration.

An alternative would be to figure out how to walk the sysfs data
structures for this, but that would be really too much effort
for something that shouldn't happen.

I think I'll just add a WARN_ON() for this case instead.

-Andi
