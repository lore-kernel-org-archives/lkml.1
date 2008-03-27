Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbYC0JEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbYC0JEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYC0JEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:04:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:31649 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYC0JEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=J0Arx2N9tOBuxIUtIFPwwX9uBn83U/qDfm+T8xW2G7L8obn5ImQZAdmRPVBK9rpdAgySJTjXIGXjoduLI6I+5/IdsIRseHXr2egBhwZ4lO4jFFGb7v8jl+AFTQ28qcj7GvbibzbWdLRD/32/qXR9gotGWncx/ZPTxXJtsFWS+Sg=
Date: Thu, 27 Mar 2008 10:08:30 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, marcus@better.se,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
Message-ID: <20080327090830.GB2778@ami.dom.local>
References: <bug-10326-10286@http.bugzilla.kernel.org/> <20080325134320.21525479.akpm@linux-foundation.org> <47EAD8A5.3070806@gmail.com> <20080326171403.ad186037.akpm@linux-foundation.org> <20080327085542.GA2778@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327085542.GA2778@ami.dom.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 09:55:42AM +0100, Jarek Poplawski wrote:
...
> sky2_poll() doesn't take napi->poll_lock; this lock is taken by
> netpoll_poll() before calling sky2_poll(). And before this hardirqs
> are disabled in write_msg().

Actually, hardirqs are disabled again before netpoll_poll() (in
netpoll_send_skb()), so sky2_poll() should need enable_irqs 2x
to justify such a warning.

Jarek P.
