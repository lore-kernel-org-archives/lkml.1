Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbXEaGLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbXEaGLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbXEaGKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:10:52 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:40242 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808AbXEaGKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:10:51 -0400
Date: Wed, 30 May 2007 23:09:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Levon <levon@movementarian.org>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, alan@lxorguk.ukuu.org.uk, davej@redhat.com,
       ak@muc.de
Subject: Re: [PATCH][OPROFILE] x86: Use for_each_possible_cpu to allocate
	msrs (was [PATCH] x86: fix oprofile double free (was Re: Multiple
	free during oprofile unload))
Message-ID: <20070531060938.GK3429@sequoia.sous-sol.org>
References: <20070531022427.GA21633@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531022427.GA21633@ghostprotocols.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo (acme@redhat.com) wrote:
> The fix for the fix needed a fix: allocate_msrs() was using
> for_each_online_cpu(), but nmi_setup uses for_each_possible_cpu(), and
> in my test machine, a Dell Poweredge 1950 I have 2 dual core Xeons,
> which makes for 4 possible cores, but wait, they are HT capable, so...
> 
> [acme@mica linux-2.6.21.3.orig]$ dmesg | grep Allowing
> SMP: Allowing 8 CPUs, 4 hotplug CPUs
> [acme@mica linux-2.6.21.3.orig]$
> 
> We have 8 possible CPUs, but only 4 online, b00m. Fix it by making
> allocate_msrs agree with nmi_setup, i.e. make both use
> for_each_possible_cpu().
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>

Thanks Arnaldo.  I noticed this earlier, but mistakenly didn't consider it
an issue aside of code needing to be cleaned up and for hotplug (which I
thought was already broken for other reasons).  And the Opteron I tested
on has possible == online.  I tested this addition on both the AMD box,
as well as an Intel box with possible > online.  All looks good.

thanks,
-chris
