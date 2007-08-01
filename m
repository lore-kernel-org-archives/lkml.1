Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbXHAXyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbXHAXyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbXHAXx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:53:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752753AbXHAXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:53:55 -0400
Date: Wed, 1 Aug 2007 16:53:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm 3/3] Freezer: Measure freezing time
Message-Id: <20070801165333.7f93c4a6.akpm@linux-foundation.org>
In-Reply-To: <200708012336.40388.rjw@sisk.pl>
References: <200708012328.23939.rjw@sisk.pl>
	<200708012336.40388.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 23:36:39 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> +	do_gettimeofday(&end);
> +	elapsed_csecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
> +	do_div(elapsed_csecs64, NSEC_PER_SEC / 100);
> +	elapsed_csecs = elapsed_csecs64;

I'd have thought that we had enough timeval library code by now to
not need to open-code things like this.

<looks around>

No, it seems that we don't.  So people keep on open-coding the same
thing, or inventing private code which shouldn't be.

<notices net/dccp/dccp.h>

What the hell is all that stuff doing in there?
