Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZHGNKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZHGNKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbZHGNKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:10:13 -0400
Received: from mail-bw0-f215.google.com ([209.85.218.215]:34614 "EHLO
	mail-bw0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbZHGNKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=L4S/SA11kg0e6o6KrNBh3XkH7vSrJfnU3iYYn2Kzpq1lXE9F+GEvlWqB9VIqIb2CcF
         esl5D7T/RolpK/nxlwLkABhJNL22tSoO0e0ggZZJJT/GlaVYRDLrgy6iySUjt5Fa6Dxb
         zgfilSuDywZeeY/xpKLflPxr9ss7X1ArWyUjI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>, "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH] acpi: fix acpi_device_{install,remove}_notify_handler() for _HID-less devices
Date: Fri, 7 Aug 2009 15:09:17 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-00246-g90bc1a6; KDE/4.2.4; i686; ; )
Cc: "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200908062141.52501.bzolnier@gmail.com> <1249606433.7301.23.camel@minggr.sh.intel.com>
In-Reply-To: <1249606433.7301.23.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908071509.17402.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 07 August 2009 02:53:53 Lin Ming wrote:
> On Fri, 2009-08-07 at 03:41 +0800, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] acpi: fix acpi_device_{install,remove}_notify_handler() for _HID-less devices
> 
> Hi,
> 
> The patch in -mm tree titled
> "acpi-fix-null-bug-for-hid-uid-string-2.patch"
> has fixed this regression.
> Would you please give it a try?
> 
> The patch attached below.
> 
> Subject: acpi: fix NULL bug for HID/UID string
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> acpi_device->pnp.hardware_id and unique_id are now allocated pointers,
> replacing the previous arrays.  acpi_device_install_notify_handler()
> oopsed on the NULL hid when probing the video device, and perhaps other
> uses are vulnerable too.  So initialize those pointers to empty strings
> when there is no hid or uid.  Also, free hardware_id and unique_id when
> when acpi_device is going to be freed.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hugh's patch also fixes the problem and I like it more than mine version
(BTW mmotm still contains older acpi-fix-null-bug-for-hid-uid-string.patch
not acpi-fix-null-bug-for-hid-uid-string-2.patch).

Andrew, could mmotm be somehow integrated with -next (the above bug was
fixed in mmotm two weeks ago already)?  If you're worried about affecting
-next's quality, worry not, it really can't be much worse than it is now
(at least we would have all outstanding patches really in the one place)..

Thanks,
Bart
