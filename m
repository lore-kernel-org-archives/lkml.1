Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbYC0KCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbYC0KCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbYC0KC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:02:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:55175 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbYC0KCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lKfZXDa2qBHfSgeaXBc3xMdV4slEjc0qJgOTRXV2fD6AHZv+yy906JVSh0VpRrknR0dHhTz5K6OHh9u8ONe4tr1HnKhtKT5o0oSP17aW2npRCPtS2IyM3di/Usu7NcXfZGlqU+kbozMJjADgG830O2Ioo//GJLoxwIVwWCSszsU=
Date: Thu, 27 Mar 2008 11:07:00 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, marcus@better.se,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
Message-ID: <20080327100700.GA2845@ami.dom.local>
References: <bug-10326-10286@http.bugzilla.kernel.org/> <20080325134320.21525479.akpm@linux-foundation.org> <47EAD8A5.3070806@gmail.com> <20080326171403.ad186037.akpm@linux-foundation.org> <20080327085542.GA2778@ami.dom.local> <20080327021812.601776b8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327021812.601776b8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 02:18:12AM -0700, Andrew Morton wrote:
...
> Anyway, the accusation is that lockdep is busted, in that it doesn't realise that
> local_irq_disable() blocks softirqs.

Usually lockdep gets this right, so I've some doubts too. But here
it's not only about softirqs; this:

> >> Mar 25 19:48:46 better kernel:  #1:  (target_list_lock){--..}, at: [<c0399c0d>]

means lockdep saw hardirqs enabled while acquiring/holding this lock.

Jarek P.
