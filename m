Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbYB1QvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbYB1QvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758443AbYB1QvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:51:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758347AbYB1QvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:51:01 -0500
Date: Thu, 28 Feb 2008 11:50:00 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Message-ID: <20080228165000.GA6856@redhat.com>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080227190519.GA14335@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227190519.GA14335@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 02:05:19PM -0500, Mathieu Desnoyers wrote:
> > +struct stop_machine_data {
> > +	int (*fn)(void *);
> > +	void *data;
> > +	struct completion done;
> > +	int run_all;
> > +} smdata;
> > +
> 
> Why do we now have to declare this static ? Can we pass it as a pointer
> to stopmachine instead ?
> 

Since the other cpus need to access 'fn', i made smdata a global.
stop_machine_run() is system-wide, so we only need one of these...

thanks,

-Jason

