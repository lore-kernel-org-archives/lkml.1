Return-Path: <linux-kernel-owner+w=401wt.eu-S2992869AbXCIBQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992869AbXCIBQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 20:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992868AbXCIBQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 20:16:28 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43969 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992869AbXCIBQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 20:16:26 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 8 Mar 2007 17:16:21 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <20070309001408.GA6801@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0703081712590.3670@alien.or.mcafeemobile.com>
References: <20070308204353.GA6733@tv-sign.ru>
 <Pine.LNX.4.64.0703081259560.7515@alien.or.mcafeemobile.com>
 <20070308215653.GA6744@tv-sign.ru> <Pine.LNX.4.64.0703081459350.4882@alien.or.mcafeemobile.com>
 <20070309001408.GA6801@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Oleg Nesterov wrote:

> Ugh. Still can't understand, probably I missed something or misread this patch.
> 
> If we shift signalfd_notify() from specific_send_sig_info/__group_send_sig_info
> to send_signal(), we have the same "list_empty()" fastpath if no signalfds are
> attached to the sighand. The difference is that we don't count sig_ignored()
> signals, which looks right to me.

Now I shifted the check into send_signal(), since signalfd now uses the 
standard dequeue_signal, and hence compete with standard signal delivery 
against the queue. This was initial Linus design.




- Davide


