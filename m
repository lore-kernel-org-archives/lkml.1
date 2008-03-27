Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYC0Ivt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYC0Ivt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbYC0Ivj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:51:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:39364 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYC0Ivi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ztto6E3HoAmZfBiSPaGgoMMrsmkCGh7LCT2lKN8bIZroimv0VLq+S0e1u/ykasF9hI1Y9v5Vw01Vz6ejg+pCtSCdPDYi2gDl+DXvhuKC9ZyMrHmR/Xb6ZmyWQjKzbEgyKM1x7zTQ4KaPTjSB8rJuqlhMh2P4Rdu2kHMHRTkwRc8=
Date: Thu, 27 Mar 2008 09:55:42 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, marcus@better.se,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
Message-ID: <20080327085542.GA2778@ami.dom.local>
References: <bug-10326-10286@http.bugzilla.kernel.org/> <20080325134320.21525479.akpm@linux-foundation.org> <47EAD8A5.3070806@gmail.com> <20080326171403.ad186037.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326171403.ad186037.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 05:14:03PM -0700, Andrew Morton wrote:
...
> > >> http://bugzilla.kernel.org/show_bug.cgi?id=10326
...
> No, it's not an irq_disable() thing, directly.
> 
> What lockdep is saying is that sky2_poll() is taking napi->poll_lock for
> writing with softirqs enabled, but net_rx_action() takes the same lock from
> within softirq context.
> 
> If sky2_poll() always takes napi->poll_lock under local_irq_disable() then
> that would be a lockdep bug.

sky2_poll() doesn't take napi->poll_lock; this lock is taken by
netpoll_poll() before calling sky2_poll(). And before this hardirqs
are disabled in write_msg(). So, theoretically lockdep could be right
if sky2_poll() would enable irqs after this. (If it were done in
netpoll - lockdep should warn before or after sky2_poll() call.)
But I really can't see any such possibility in sky2_poll().

Regards,
Jarek P.
