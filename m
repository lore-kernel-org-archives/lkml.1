Return-Path: <linux-kernel-owner+w=401wt.eu-S1765462AbYEBOev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765462AbYEBOev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760685AbYEBOek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:34:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55751 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760550AbYEBOej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:34:39 -0400
From: Chris Mason <chris.mason@oracle.com>
To: jeffschroeder@computer.org
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 10:34:07 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Jan Engelhardt" <jengelh@medozas.de>, "Jeff Mahoney" <jeffm@suse.com>,
       "Tim Gardner" <tim.gardner@canonical.com>,
       linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       "John Johansen" <jjohansen@suse.de>
References: <200804291601.32945.chris.mason@oracle.com> <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
In-Reply-To: <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021034.08358.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Jeff Schroeder wrote:

[ Btrfs oops with apparmor patched in ]

> Make is not my forte, but here is a working test to see if apparmor
> exists in Ubuntu 8.04.
> Maybe have make apply a patch to the btrfs source if this test
> succeeds? Does this work in SUSE?
>
> http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_test
>_for_btrfs.patch
>

Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell if 
the kernel has the patch.  Lets go back to Jeff's suse patch:

/*
 * Even if AppArmor isn't enabled, it still has different prototypes.
 * Add more distro/version pairs here to declare which has AppArmor applied.
 */
#if defined(CONFIG_SUSE_KERNEL)
# if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
# define REMOVE_SUID_PATH 1
# endif
#endif

Could someone from Ubuntu please suggest a replacement for CONFIG_SUSE_KERNEL 
and KERNEL_VERSION(2,6,22) that would correspond with ubuntu kernels shipped 
with apparmor?  We don't need some define from the apparmor patch, just a 
global flag that says it comes from ubuntu is enough.

-chris
