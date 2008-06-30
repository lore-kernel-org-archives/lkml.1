Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbYF3Uqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbYF3Uqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYF3Uqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:46:42 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:12851 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYF3Uql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:46:41 -0400
From: "Pan, Weimin" <weimin.pan@hp.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jun 2008 20:45:47 +0000
Subject: RE: Why  get_user_pages fails?
Thread-Topic: Why  get_user_pages fails?
Thread-Index: Acja6rps06THwKW2QOSaUN7xxAkZcwABTshw
Message-ID: <6B24EEDBA38D764293B27C04FE414CC64E4091DF15@G1W0491.americas.hpqcorp.net>
References: <6B24EEDBA38D764293B27C04FE414CC64E4091DE4E@G1W0491.americas.hpqcorp.net>
 <20080630135139.2b53c93d@bike.lwn.net>
In-Reply-To: <20080630135139.2b53c93d@bike.lwn.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I totally agree with you that the best solution is to bypass the Linux VM.
The reason to continue using get_user_pages() is that we can leverage the existing kernel driver - the SCST.

Do I have a way to map a range of phy memory to user virtual address and have the page structures built for that memory region?
I know remap_pfn_range() doesn't work.

Weimin

-----Original Message-----
From: Jonathan Corbet [mailto:corbet@lwn.net]
Sent: Monday, June 30, 2008 2:52 PM
To: Pan, Weimin
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why get_user_pages fails?

On Mon, 30 Jun 2008 19:32:41 +0000
"Pan, Weimin" <weimin.pan@hp.com> wrote:

> I booted the kernel and set "mem=512M" and then mmapped the physical
> memory above 512M to user space and got the user space virtual address
> for that memory. When I passed that address to my driver to do direct
> IO. The get_user_pages() in my driver fails. I found that this is due
> to the VM_IO and VM_PFNMAP are set. Does that mean the page structures
> are not built when I mmapped physical memory to user space (using
> remap_pfn_range())?
>
> Do I have a way to solve this problem? How can I map the physical
> memory to user space virtual address and can pass this address to my
> driver to do direct IO by using get_user_pages() function?

In this situation, you already know where the memory sits in physical space, and there's no point in trying to pin it.  So a call to
get_user_pages() is entirely unnecessary.  You're bypassing the Linux VM, so bypass it entirely.

However, this whole scheme seems a little...baroque.  Why are you doing things this way?  As always in such cases, posting your code can enable others to help you find the right solution to your problem.

jon
