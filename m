Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZGWKez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZGWKez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZGWKez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:34:55 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:10588 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZGWKey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:34:54 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zz1432R98dNaf6Wzz1202hzzz32i6bh1f9i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KN8DDW-03-9MR-01
Message-ID: <4A683CC0.90509@amd.com>
Date: Thu, 23 Jul 2009 12:34:40 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: This combination of AMDprocessors is not suitable for SMP?
References: <4A6816AD.2060700@msgid.tls.msk.ru>
In-Reply-To: <4A6816AD.2060700@msgid.tls.msk.ru>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2009 10:34:42.0173 (UTC) FILETIME=[3040F2D0:01CA0B81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> (yes there's no typo in $subject, it's an old formatting
> bug in printk).
> 
> When booting kvm guest on an AMD CPU, guest kernel prints
> this warning:
> 
>  WARNING: This combination of AMDprocessors is not suitable for SMP.
> 
> be it SMP or UP guest.  What's wrong with this "combination",
> and can it be fixed?
The qemu64 CPU model KVM injects into the guest lets it see an AMD K7 
with 64bit extension. Only some AMD K7 (Athlon-MP) were certified for 
SMP support, so this code warns the user about an unsupported hardware.
When running KVM you can ignore this warning, as it only applies to 
non-KVM capable processors and has no meaning for virtual SMP anyway.

If you like this warning to disappear, you can use "-cpu host" (and 
probably loose migration capability) or wait for the new safe64 CPU 
type, which will use family 15 instead of 6.

Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany
Tel: +49 351 448 3567 12
----to satisfy European Law for business letters:
Advanced Micro Devices GmbH
Karl-Hammerschmidt-Str. 34, 85609 Dornach b. Muenchen
Geschaeftsfuehrer: Thomas M. McCoy; Giuliano Meroni
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

