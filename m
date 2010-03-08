Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0CHPBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:01:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab0CHPB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:01:28 -0500
Message-ID: <4B951143.1050807@suse.cz>
Date: Mon, 08 Mar 2010 16:01:23 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org, elendil@planet.nl, cloos@jhcloos.com
Subject: Re: [PATCH 0/2] v4 kconfig: place git SHA1 in .config output if in
 SCM
References: <20100305194305.GA23009@linux.vnet.ibm.com>
In-Reply-To: <20100305194305.GA23009@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.3.2010 20:43, Paul E. McKenney wrote:
> This patch appends the localversion string to the Linux kernel version.
> For example, in a git tree with uncommitted changes, the .config file
> might start as follows (but with leading hash marks):
> 
> 	Automatically generated make config: don't edit
> 	Linux kernel version: 2.6.33-01836-g90a6501-dirty
> 	Mon Mar  1 17:05:59 2010
> 
> The "-01836-g90a6501-dirty" string is added by this patch.

kbuild in linux-next already has
commit 85a256d8e0116c8f5ad276730830f5d4d473344d
Author: David Rientjes <rientjes@google.com>
Date:   Wed Jan 13 13:01:05 2010 -0800

    kbuild: improve version string logic

which results in a scripts/setlocalversion call during each build. And
with CONFIG_LOCALVERSION_AUTO, it stores exactly the string you want in
include/config/kernel.release. So we could change kconfig to read that
file instead of building the version string again. To also cover the
!CONFIG_LOCALVERSION_AUTO case, we can add a
include/config/kernel.release.full file to hold the full string each time.

Sorry for jumping in so late in the discussion, I had a bit of backlog
in mail directed to me and linux-kbuild@vger.kernel.org, let alone LKML ;).

Michal
