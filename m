Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbYG3XsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbYG3XsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYG3Xr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:47:57 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:54039 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbYG3Xr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:47:56 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, Marco Berizzi <pupilla@hotmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: commit a29ccf6f823a84d89e1c7aaaf221cf7282022024 break console on slackware 12.1
Date: Thu, 31 Jul 2008 09:47:45 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <o9v194tb7pd82d6ohopqarfinb1smd3lkr@4ax.com>
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl> <200807291815.13907.alistair@devzero.co.uk> <BAY103-W38794846AA924235B38E47B2820@phx.gbl> <488FAFE3.4040001@am.sony.com> <ntcv845p7kpiob7iqf6d1m8buj116ug4nv@4ax.com> <4890CB06.9040106@am.sony.com>
In-Reply-To: <4890CB06.9040106@am.sony.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 13:11:50 -0700, Tim Bird <tim.bird@am.sony.com> wrote:

>Grant Coady wrote:
>> I have the same issue, the line drawing characters are displayed as an odd 
>> looking C with a tail.  Slackware-12.1 and Slamd64-12.1.
>> 
>> .configs:
>>   http://bugsplatter.mine.nu/test/boxen/pooh/config-2.6.27-rc1a.gz
>>   http://bugsplatter.mine.nu/test/boxen/pooh64/config-2.6.27-rc1a.gz
>> 
>> CONFIG_CONSOLE_TRANSLATIONS=y ?? yes it's on
>
>This looks like an operator precedence bug introduced by
>the patch.
>
>Normally I would test this myself before sending it out, but
>I can't test 2.6.27-rc1 right now on my hardware due to another
>bug in the 2.6.27-rc1 tree.
>
>Can you please try the following patch and let me know if that
>fixes the problem?

Hi Tim,
Yep, this patch fixes the issue.  Tested on slackware-12.1 with the 
default lilo option '#append=" vt.default_utf8=0"' commented out.

Grant.

>
>Thanks,
> -- Tim
>
>diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
>index 14c0e91..8c8119f 100644
>--- a/include/linux/vt_kern.h
>+++ b/include/linux/vt_kern.h
>@@ -74,7 +74,7 @@ void con_protect_unimap(struct vc_data *vc, int rdonly);
> int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
>
> #define vc_translate(vc, c) ((vc)->vc_translate[(c) |			\
>-					(vc)->vc_toggle_meta ? 0x80 : 0])
>+					((vc)->vc_toggle_meta ? 0x80 : 0)])
> #else
> #define con_set_trans_old(arg) (0)
> #define con_get_trans_old(arg) (-EINVAL)
>
>

