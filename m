Return-Path: <linux-kernel-owner+w=401wt.eu-S935503AbXFFUYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935503AbXFFUYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbXFFUYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:24:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59920 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650AbXFFUYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:24:12 -0400
Date: Wed, 6 Jun 2007 21:24:09 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: generic bool and sparse errors?
Message-ID: <20070606202409.GY4095@ftp.linux.org.uk>
References: <4666FD0A.4060609@intel.com> <466708D8.90208@student.ltu.se> <46671668.4090805@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46671668.4090805@intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 01:17:44PM -0700, Kok, Auke wrote:
> well the sparse warning is about signedness. Either sparse needs to "know" 
> that bool is unsigned, or the kernel headers need to somehow make bool 
> unsigned... the latter choice would come down to just that, but it doesn't 
> look like a good idea to me either somehow.

sparse treats _Bool as 1-bit integer type.  It's considerably more
complicated beast; for one thing (_Bool)2 is 1, not 0.  For another,
several places make unpleasant assumptions that size in bits is a
multiple of bits_in_char.  Which would be fine, but sparse has it
set to 1 for _Bool.  With obvious results...
