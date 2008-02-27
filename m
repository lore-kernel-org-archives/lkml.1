Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYB0T7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYB0T7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbYB0T7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:59:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbYB0T7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:59:05 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/2] firewire: endianess fix
Date: Wed, 27 Feb 2008 14:58:28 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Kristian Hoegsberg <krh@bitplanet.net>
References: <20080220220326.GA22328@uranus.ravnborg.org> <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de> <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
In-Reply-To: <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271458.28401.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008 06:24:17 am Stefan Richter wrote:
> The generation of incoming requests was filled in in wrong byte order on
> machines with big endian CPU.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: sparclinux@vger.kernel.org
> Cc: linuxppc-dev@ozlabs.org
> ---
>
> This patch is a shot in the dark, based on a warning when building with
> C=1 CHECKFLAGS="-D__CHECK_ENDIAN__".  Is it really a fix, or was the
> previous code accidentally correct?
>
> This needs to be tested on different big endian PCs, if possible with
> the Apple Uninorth FireWire controller and other types of controllers.
> One test which involves ohci->request_generation is simply with an SBP-2
> device (harddisk, CD-ROM...).  Does SBP-2 login etc. work?

Works just fine with the Apple UniNorth controller in my powerbook in cursory 
testing. Tested with multiple sbp2 hard disks, plugging and unplugging, 
mounting and unmounting, etc.

> If possible, also test whether the device remains accessible after
> forcing a bus reset, e.g. by "echo br short > firecontrol".  You need
> the easy to build utility firecontrol and a libraw1394 with "juju"
> backend.  See wiki.linux1394.org for directions.

Forgot to check that it survived bus resets. Will try to double-check that 
tonight. I don't have any other ppc systems w/firewire controllers handy at 
the moment to try other controllers, but can probably manage to get one set 
up soon...

-- 
Jarod Wilson
jwilson@redhat.com
