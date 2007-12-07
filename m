Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbXLGN4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbXLGN4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 08:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXLGN4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 08:56:22 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:63209 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbXLGN4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 08:56:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xBhn96X149271z8RI+ZLzwsRqV6Y6sYVi8E+LS9sps1X/aLoLEY3A9FuDydN9TLf5YwFRj54VTK5lITDsgPq2+DgWirh0AAoD66Sfjj9uOIpyZC8pHq1H/syeD+2zCqatlhJaMMHimQtlAXfgj1sZkfum1e8d0r8JK/MKkipGTA=
Message-ID: <851fc09e0712070556g13741a0vc56348ffbbb57a1d@mail.gmail.com>
Date: Fri, 7 Dec 2007 21:56:18 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/4 -mm] kexec based hibernation -v7 : kimgcore
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Pavel Machek" <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Kexec Mailing List" <kexec@lists.infradead.org>
In-Reply-To: <200712071333.06836.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197042824.24045.64.camel@caritas-dev.intel.com>
	 <200712071333.06836.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 8:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, 7 of December 2007, Huang, Ying wrote:
> > This patch adds a file in proc file system to access the loaded
> > kexec_image, which may contains the memory image of kexeced
> > system. This can be used by kexec based hibernation to create a file
> > image of hibernating kernel, so that a kernel booting process is not
> > needed for each hibernating.
>
> Hm, I'm not sure what you mean.
>
> Can you explain a bit, please?

The normal kexec based hibernation procedure is as follow:

1. kexec_load the kernel image and initramfs
2. jump to hibernating kernel
3. the normal boot process of kexeced kernel
4. jump back to hibernated kernel
5. execute ACPI methods
6. jump to hibernating kernel
7. write memory image of hibernated kernel
8. go to ACPI S4 state

With kimgcore:

A. Prepare a memory image of hibernation kernel:

A.1 kexec_load the kernel image and initramfs
A.2 jump to hibernating kernel
A.3 the normal boot process of kexeced kernel
A.4 jump back to hibernated kernel
A.5 save the memory image of hibernating kernel via kimgcore

The normal hibernate process is as follow:

1. kexec load the kimgcore of hibernatin kernel
2. jump to the hibernating kernel
3. execute ACPI methods
4. jump to hibernating kernel
5. write memory image of hibernated kernel
6. go to ACPI S4 state

So the boot process of hibernating kernel needs only once unless the
hardware configuration is changed.

Best Regards,
Huang Ying
