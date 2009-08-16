Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZHPOlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZHPOlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZHPOlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:41:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59953 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZHPOlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:41:21 -0400
Date: Sun, 16 Aug 2009 15:41:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       Zeev Tarantov <zeev.tarantov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] [hwmon] linux 2.6.31-rc6 regression
Message-ID: <20090816144107.GA8165@srcf.ucam.org>
References: <12d7e64c0908150329k1bf123der18e74112c5b9cd97@mail.gmail.com> <20090816010303.GA9588@srcf.ucam.org> <20090816053735.GB1998@phenom2.trippelsdorf.de> <20090816093251.GA1027@srcf.ucam.org> <4A881A27.6090603@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A881A27.6090603@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 04:39:35PM +0200, Stefan Richter wrote:
> Matthew Garrett wrote:
>> On Sun, Aug 16, 2009 at 07:37:35AM +0200, Markus Trippelsdorf wrote:
>>> On Sun, Aug 16, 2009 at 02:03:03AM +0100, Matthew Garrett wrote:
>>>> The hwmon driver is attempting to allocate a region that's also 
>>>> used by your ACPI firmware. There's no way to synchronise access 
>>>> between the kernel and the firmware, so allowing both is 
>>>> potentially racy - we've seen numerous cases where the combination 
>>>> results in the system incorrectly generating critical temperatuer 
>>>> shutdowns, for instance, when some other indexed access gets 
>>>> interpreted as the temperature or when the hwmon chip's state 
>>>> machine is confused. The failure of hwmon to bind is a feature 
>>>> here, not a bug. You can override it with  
>>>> acpi_enforce_resources=no on the kernel command line.
>>> But we don't introduce »features« that break hardware monitoring on
>>> numerous machines in rc6 normally, IIRC.
>>> If this so important and critical to you, than just add a »hyperstrict«
>>> parameter to acpi_enforce_resources or make »lax« the default.
>>
>> It's not - 2.6.29 had this behaviour, and it got broken in 2.6.30. This 
>> restores the status quo.
>
> Then why did my 2.6.29 did _not_ have this behavior?
> (here: ASUS M3A78-EM, it87 driver)

Some other bug?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
