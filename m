Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbXLWFKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbXLWFKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 00:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbXLWFKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 00:10:34 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1805 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750815AbXLWFKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 00:10:33 -0500
Message-ID: <476DED90.4040402@myri.com>
Date: Sun, 23 Dec 2007 00:09:36 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DE07A.4000204@garzik.org>
In-Reply-To: <476DE07A.4000204@garzik.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2007 11:13 PM, Jeff Garzik wrote:
>
> The facts as they exist today:
>
> 1) Existing 256-byte config space devices have been known put
> capabilities in the high end (>= 0xc8) of config space.
>
> 2) It is legal for PCI-Express to put capabilities anywhere in PCI
> config space, including extended config space.  (I hope our PCI cap
> walking code checks for overruns...)





You make it sound almost as if the capability list that starts in
regular conf-space could cross into extended conf-space >= 256). That's
not true, the capability lists in the regular conf-space and the
extended conf-space are really separate, they use a different structure
for linking (different number of bits to define the capability IDs), a
different starting point, different capability IDs definition tables.
The regular conf-space and the extended conf-space are really independant.




>
> 3) Most new machines ship with PCI-Express devices with extended
> config space.
>
> Therefore it is provable /possible/, and is indeed logical to conclude
> that capabilities in extended config space will follow the same
> pattern that existing hw designers have been following...  but only
> once the current OS's have stable extended-config-space support.
>
> Maybe that day will never come, but it is nonetheless quite possible
> within today's PCI Express spec for this to happen.



I agree with that statement. In fact it is already quite useful today. I
am doing a lot of support activities where extended-conf-space is a must
for troubleshooting. It was important enough for us that we have
user-tools that allows us to access mmconfig-space for pci-express even
on systems that don't advertise a MCFG attribute (as long as the chipset
supports it, we have reverse-engineered the location of the "mmconfig
bar" for a few chipsets including nvidia chipsets, for Intel it is well
documented, and there are couple others).



Loic

