Return-Path: <linux-kernel-owner+w=401wt.eu-S933684AbYEUAn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbYEUAn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759537AbYEUAnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:43:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56097 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759105AbYEUAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:43:08 -0400
Date: Wed, 21 May 2008 01:43:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] bt8xx: unaligned access
Message-ID: <20080521004306.GC28946@ZenIV.linux.org.uk>
References: <E1JycFh-0004sc-Re@ZenIV.linux.org.uk> <1211330323.5915.226.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211330323.5915.226.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:38:43PM -0700, Harvey Harrison wrote:
> > -		type = be16_to_cpup((u16*)(ee+4));
> > +		type = get_unaligned_be16((__be16 *)(ee+4));
> 
> The casts aren't strictly necessary here.  Any reason to keep it?

I'd rather have them explicit *and* make get_unaligned_* take the pointer
of right type, so that it'd eat things like void * and __be16 *, but warn
on int * et.al.  One too many brainos seen in that area...
