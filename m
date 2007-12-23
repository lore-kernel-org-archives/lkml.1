Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbXLWF1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbXLWF1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 00:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbXLWF1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 00:27:34 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1781 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850AbXLWF1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 00:27:33 -0500
Message-ID: <476DF1A6.3060900@myri.com>
Date: Sun, 23 Dec 2007 00:27:02 -0500
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
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org>
In-Reply-To: <476DE98F.2010009@garzik.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/22/2007 11:52 PM, Jeff Garzik wrote:
>
> Absolutely.
>
> But regardless of problems, enabling should be done globally, not per
> device...  




The "enabling globally" requirement, i.e. not per-device, neither
depending on reg >= 256 seems a very debatable assumption (IMHO a big
mistake) that seems to be responsible for many of the problems seen in
the past.



There might be for a very long time AMD-architectures where
extended-conf-space access for pci-express device works and is
beneficial (and where mmconf is not supported by the hardware on
non-pci-express devices). You are basically saying you don't want ever
to support extended-conf-space globally for those systems, where it
would be so easy to precisely use mmconf *only* when attempting
*extended-conf-space * (>= 256) to some device  (that provides a strong
guarantee that you will never break anything unless somebody actually
tries to use the extended-conf-space).


Supporting extended-conf-space is independant of the issue of using
mmconf for legacy conf-space. There is no real reason to use the same
method to access both. I have seen several arguments used that were
implying that, and they all seem really bogus to me. Not only are the
two ranges (<= 256 and >= 256) structurally independant (you have
totally independant capabilities lists that are independantly organized
in each of them), even if they were not there is no consistency issue
that cannot be dealt with a memory barrier, and the concern about taking
an extra branch for each pci-conf-space access is also bogus once you
look at the numbers.


By possibly using different implementations for the two ranges you avoid
introducing a new API, you avoid taking risks with mmconf when you don't
need it. That doesn't preclude using mmconf for everything either if the
user requests it or based on enough knowledge of the system to be sure
nothing will break.



Loic

