Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZHQNxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZHQNxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZHQNxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:53:38 -0400
Received: from ru.mvista.com ([213.79.90.228]:37563 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752380AbZHQNxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:53:38 -0400
Date: Mon, 17 Aug 2009 17:53:37 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/8] powerpc/qe&cpm: Implement static inline stubs for
 non-QE/CPM builds
Message-ID: <20090817135337.GA6251@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090814222453.GA9568@oksana.dev.rtsoft.ru>
 <20090814222549.GD14458@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090814222549.GD14458@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 02:25:49AM +0400, Anton Vorontsov wrote:
[....]
> +#ifdef CONFIG_CPM
>  int cpm_command(u32 command, u8 opcode);
> +#else
> +static inline int cpm_command(u32 command, u8 opcode)
> +{
> +	return -ENOSYS;
> +}
> +#endif /* CONFIG_CPM */

It appers that fsl_qe_udc.h defines its own inlined version, and so
fsl_qe_udc.c's build breaks:

In file included from drivers/usb/gadget/fsl_qe_udc.c:44:
fsl_qe_udc.h:432: error: redefinition of ‘qe_issue_cmd’
arch/powerpc/include/asm/qe.h:153: error: previous definition of ‘qe_issue_cmd’ was here

I didn't notice that earlier because USB_GADGET_FSL_QE isn't enabled
in any defconfig.

I'll send v2 soon.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
