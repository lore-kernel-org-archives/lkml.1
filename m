Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYGTVPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYGTVPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 17:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYGTVPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 17:15:04 -0400
Received: from homer.mvista.com ([63.81.120.158]:44560 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbYGTVPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 17:15:03 -0400
Subject: Re: [patch 5/3] fastboot: sync the async execution before
	late_initcall and move level 6s (sync) first
From: Daniel Walker <dwalker@mvista.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Rene Herman <rene.herman@keyaccess.nl>,
       Simon Arlott <simon@fire.lp0.eu>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <20080720090041.5924f5ff@infradead.org>
References: <20080720085924.122feb2b@infradead.org>
	 <20080720090041.5924f5ff@infradead.org>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 14:14:59 -0700
Message-Id: <1216588499.6971.1.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-20 at 09:00 -0700, Arjan van de Ven wrote:
> @@ -775,6 +776,11 @@ static void __init do_initcalls(void)
>                 }
>                 if (phase == 1 && call >= __async_initcall_end)
>                         phase = 2;
> +               if (phase == 2 && call >= __device_initcall_end) {
> +                       phase = 3;
> +                       /* make sure all async work is done before level 7 */
> +                       flush_workqueue(async_init_wq);
> +               }
>                 if (phase != 1)
>                         do_one_initcall(*call);
>         }

Did this impact the boot time improvements at all?

Daniel

