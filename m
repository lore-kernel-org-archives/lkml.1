Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbXFZX1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbXFZX1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbXFZXNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:13:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760468AbXFZXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:13:50 -0400
Date: Tue, 26 Jun 2007 16:13:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, josh@freedesktop.org,
       dipankar@in.ibm.com
Subject: Re: [PATCH] Force rcutorture tasks to spread over CPUs
Message-Id: <20070626161317.767d5ec0.akpm@linux-foundation.org>
In-Reply-To: <20070613042804.GA6132@linux.vnet.ibm.com>
References: <20070613042804.GA6132@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 21:28:04 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> +	while (!startwriters)
> +		barrier();	/* Force scheduler to spread over CPUs. */

one wonders whether a cpu_relax() would be a bit nicer here.  That implicitly
does a barrier().

This patch doesn't make much sense for non-SMP builds?
