Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYAFTbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYAFTbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 14:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYAFTbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 14:31:07 -0500
Received: from lixom.net ([66.141.50.11]:56480 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYAFTbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 14:31:06 -0500
Date: Sun, 6 Jan 2008 13:40:05 -0600
From: Olof Johansson <olof@lixom.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, mpm@selenic.com
Subject: Re: [patch 2/5] move WARN_ON() out of line
Message-ID: <20080106194005.GA7992@lixom.net>
References: <20080105190713.73745ec6@laptopd505.fenrus.org> <20080105190959.1880f1c4@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105190959.1880f1c4@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 07:09:59PM -0800, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Olof Johansson <olof@lixom.net>
> Acked-by: Matt Meckall <mpm@selenic.com>
> 
> A quick grep shows that there are currently 1145 instances of WARN_ON
> in the kernel. Currently, WARN_ON is pretty much entirely inlined,
> which makes it hard to enhance it without growing the size of the kernel
> (and getting Andrew unhappy).
> 
> This patch build on top of Olof's patch that introduces __WARN,
> and places the slowpath out of line. It also uses Ingo's suggestion
> to not use __FUNCTION__ but to use kallsyms to do the lookup;
> this saves a ton of extra space since gcc doesn't need to store the function
> string twice now:
> 
> 3936367  833603  624736 5394706  525112 vmlinux.before
> 3917508  833603  624736 5375847  520767 vmlinux-slowpath
> 
> 15Kb savings...
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Acked-by: Olof Johansson <olof@lixom.net>

