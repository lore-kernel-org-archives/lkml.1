Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbZCNIov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbZCNIov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZCNIol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:44:41 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:59613 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbZCNIok convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:44:40 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH][0/8] PM: Rework suspend-resume ordering to avoid problems with shared interrupts
Date: Sat, 14 Mar 2009 09:44:35 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org
References: <200902221837.49396.rjw@sisk.pl> <200903082028.03720.elendil@planet.nl> <200903082150.55377.rjw@sisk.pl>
In-Reply-To: <200903082150.55377.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903140944.37081.elendil@planet.nl>
X-OriginalArrivalTime: 14 Mar 2009 08:44:37.0777 (UTC) FILETIME=[1B9CD810:01C9A481]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Rafael J. Wysocki wrote:
> > # These don't need restoring anymore?
>
> I think they generally do, but the restored values may (and often are)
> identical to the current ones.
>
> >    -pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x4, writing 0xe0500004)
> >    -pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
> >    -pci 0000:00:03.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
> >    -pci 0000:00:03.0: restoring config space at offset 0x4 (was 0xfed12004, writing 0xe0600004)
> >    -pci 0000:00:03.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
> >    -pci 0000:00:03.2: restoring config space at offset 0x8 (was 0x1, writing 0x2031)
> >    -pci 0000:00:03.2: restoring config space at offset 0x7 (was 0x1, writing 0x2021)
> >    -pci 0000:00:03.2: restoring config space at offset 0x6 (was 0x1, writing 0x2019)
> >    -pci 0000:00:03.2: restoring config space at offset 0x5 (was 0x1, writing 0x2011)
> >    -pci 0000:00:03.2: restoring config space at offset 0x4 (was 0x1, writing 0x2009)
> >    -pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00001)
[...]
> > # These have moved down to late resume.
>
> That's a bit strange.  It looks like the registers changed after we had
> restored them during "early" resume.  So either we hadn't actually
> restored them (it would be interesting to find out why), or they really
> changed (again, it would be interesting to see why).
>
> >    -uhci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> >    -uhci_hcd 0000:00:1a.0: restoring config space at offset 0x8 (was 0x1, writing 0x2081)
> >    -uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
> >    -uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
> >    -uhci_hcd 0000:00:1a.1: restoring config space at offset 0x8 (was 0x1, writing 0x20a1)
> >    -uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)

These changes look to have been reverted somehow with rc8 + your latest
patch set. Not sure if it's due to changes in the patches, or just an
effect of local circumstances (such as (un)suspending while the system
is docked). Or sun spots of course.

The "restoring config space" messages now look virtually the same
as for rc5, only some messages for the ricoh-mmc module are still
"missing", but I'm not worried about that.

Cheers,
FJP
