Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbZCCARf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbZCCARf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760041AbZCCAQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:16:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760036AbZCCAQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:16:39 -0500
Date: Mon, 2 Mar 2009 16:16:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH mainline] menu: fix embedded menu snafu
Message-Id: <20090302161602.a4eea5d9.akpm@linux-foundation.org>
In-Reply-To: <20090302141406.13d5ef1f.randy.dunlap@oracle.com>
References: <20090302141406.13d5ef1f.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 14:14:06 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> The COMPAT_BRK kconfig symbol does not depend on EMBEDDED,
> but it is in the midst of the EMBEDDED menu symbols, so it mucks
> up the EMBEDDED menu.  Fix by moving it to just after all of
> the EMBEDDED menu symbols.  Also, surround all of the
> EMBEDDED symbols with "if EMBEDDED"/"endif" so that this
> EMBEDDED block is clearer.

This patch causes weird unintended breakage, methinks.

x86_64 allnoconfig does:

mm/bootmem.c: In function 'mark_bootmem':
mm/bootmem.c:321: warning: control reaches end of non-void function

because

        }
        BUG();
}

gets preprocessed down to

        }
        ;
}

because all BUG-related config options got removed:

akpm2:/usr/src/25> make allnoconfig
scripts/kconfig/conf -n arch/x86/Kconfig
#
# configuration written to .config
#
akpm2:/usr/src/25> grep BUG .config
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_INPUT_EVBUG is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_DEBUG_MEMORY_INIT=y


I think I'll wait for version 2...
