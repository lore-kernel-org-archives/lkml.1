Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXCEHie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXCEHie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbXCEHie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:38:34 -0500
Received: from mx1.suse.de ([195.135.220.2]:55700 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097AbXCEHid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:38:33 -0500
Message-ID: <45EBC8F2.4040501@suse.de>
Date: Mon, 05 Mar 2007 08:38:26 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, benh@kernel.crashing.org
Subject: Re: [patch] Fixes and cleanups for earlyprintk aka boot console.
References: <45DADD15.7070809@suse.de> <17899.39250.247475.777798@cargo.ozlabs.ibm.com>
In-Reply-To: <17899.39250.247475.777798@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Gerd Hoffmann writes:
> 
>> This patch fixes the console selection code to *not* consider a boot
>> console a full-featured one, so the first non-boot console registering
>> will become the default console instead.  This way the unregister call
>> for the boot console in the register_console() function actually
>> triggers and the handover from the boot console to the real console
>> device works smoothly.  Added a printk for the handover, so you know
>> which console device the output goes to when the boot console stops
>> printing messages.
> 
> You have removed functionality that is useful for debugging, that 3
> architectures had, namely a way to keep using the early boot console
> and not replace it with a console that comes later, using a kernel
> command line option.  Perhaps you could provide a way to do that in
> your patch.

--verbose please.  I don't think I broke that.

I've seen code for that in i386/x86_64 and one of the other archs (via
earlyprintk=foo,keep).  The code clears now the CON_BOOT flag in case
keep is present, which has the wanted effect:  The earlyprintk console
will not be replaced.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
