Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZDWX7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZDWX7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbZDWX7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:59:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbZDWX7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:59:43 -0400
Date: Thu, 23 Apr 2009 16:57:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
Message-Id: <20090423165723.16c9f566.akpm@linux-foundation.org>
In-Reply-To: <49F0C817.8050407@caviumnetworks.com>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
	<49F0C817.8050407@caviumnetworks.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 12:57:11 -0700
David Daney <ddaney@caviumnetworks.com> wrote:

> > +static inline __attribute__((const))
> > +bool single_bit_set(unsigned long n)
> > +{
> > +        return (n != 0 && ((n & (n - 1)) == 0));
> > +}
> > +
> > +
> 
> 
> It would be nice to be able to override this per architecture.
> 
> For example a more efficient implementation on CPUs that have a 
> population count instruction (__builtin_popcountl()) might be:
> 
> static inline __attribute__((const))
> bool singe_bit_set(unsigned long n)
> {
> 	return __builtin_popcountl(n) == 1;
> }

Already done, via hweight_long().
