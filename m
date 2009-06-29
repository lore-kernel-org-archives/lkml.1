Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZF2SPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZF2SPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZF2SPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:15:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:33101 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbZF2SPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:15:09 -0400
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
From: Petr Tesarik <ptesarik@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       David Daney <ddaney@caviumnetworks.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090424104651.7c751735.akpm@linux-foundation.org>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
	 <49F0C817.8050407@caviumnetworks.com>
	 <20090423165723.16c9f566.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0904240632240.16107@localhost.localdomain>
	 <20090424104651.7c751735.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Mon, 29 Jun 2009 20:15:11 +0200
Message-Id: <1246299311.7698.19.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton píše v Pá 24. 04. 2009 v 10:46 -0700:
> On Fri, 24 Apr 2009 06:40:39 -0400 (EDT) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> 
> >   so it would be a simple matter to define the bit set boolean in
> > terms of hweight_long(), yes?  so what about, in bitops.h:
> > 
> >   static inline bool
> >   exactly_one_bit_set(unsigned long w)
> >   {
> > 	return hweight_long(w) == 1;
> >   }
> > 
> >   static inline bool
> >   more_than_one_bit_set(unsigned long w)
> >   {
> > 	return hweight_long(w) > 1;
> >   }
> > 

Andrew, you must be kidding! Are you seriously suggesting to replace a
simple and instruction with a call to an extern library function with 17
instructions (not including the call and ret)?

I'd better check the use of hweight in the kernel to eradicate as many
calls to it as possible...

Petr Tesarik


