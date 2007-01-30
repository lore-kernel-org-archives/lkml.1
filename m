Return-Path: <linux-kernel-owner+w=401wt.eu-S1751756AbXA3TdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbXA3TdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXA3TdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:33:04 -0500
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:56776 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbXA3TdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:33:01 -0500
In-Reply-To: <17854.32201.131104.928581@cargo.ozlabs.ibm.com>
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com> <20070128.153707.30184351.davem@davemloft.net> <m1tzyammv0.fsf@ebiederm.dsl.xmission.com> <20070128.212554.23015561.davem@davemloft.net> <1170050737.26655.233.camel@localhost.localdomain> <m1sldukxwm.fsf@ebiederm.dsl.xmission.com> <1170102158.26655.273.camel@localhost.localdomain> <17854.32201.131104.928581@cargo.ozlabs.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <A6651BCA-2975-4C5C-9A2C-1B4461B0FEEA@kernel.crashing.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, tony.luck@intel.com,
       grundler@parisc-linux.org, jeff@garzik.org,
       David Miller <davem@davemloft.net>, greg@kroah.com,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz, mingo@elte.hu
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/6] MSI portability cleanups
Date: Tue, 30 Jan 2007 20:32:19 +0100
To: Paul Mackerras <paulus@samba.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I just got an answer from the hypervisor architects.  It turns out
> that the hardware _does_ prevent the device from sending MSI messages
> to another partition.  The OS _can_ write whatever it likes to the MSI
> address and data registers.  It can potentially lose interrupts (or, I
> expect, get the device isolated by EEH) but it can't disrupt another
> partition.

The OS however has to write the values the HV wants to
the device, or things won't work -- so the HV can just
as well do it itself.  Also, pulling all the work into
the HV makes for a cleaner, more generic design (who
knows what hardware will show up within the next few
years, the HV interface had better be prepared).


Segher

