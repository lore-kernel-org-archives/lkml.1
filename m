Return-Path: <linux-kernel-owner+w=401wt.eu-S965519AbXBGOcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbXBGOcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161336AbXBGOcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:32:00 -0500
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:34359 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965519AbXBGOcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:32:00 -0500
Message-ID: <45C9E320.3070001@gentoo.org>
Date: Wed, 07 Feb 2007 09:33:04 -0500
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0b1 (X11/20061221)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/6] workqueue: make cancel_rearming_delayed_workqueue()
 work on idle dwork
References: <20070206233016.GA108@tv-sign.ru>
In-Reply-To: <20070206233016.GA108@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> cancel_rearming_delayed_workqueue(dwork) will hang forever if dwork was not
> scheduled, because in that case cancel_delayed_work()->del_timer_sync() never
> returns true.

Thanks! We hit this problem before with the zd1211rw driver and avoided 
using cancel_rearming_delayed_workqueue() for this reason. I never did 
get around to looking into if the function itself could be fixed, 
although I see not much effort would have been needed :)

Daniel

