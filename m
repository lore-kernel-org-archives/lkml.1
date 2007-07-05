Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbXGEQnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbXGEQnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbXGEQng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:43:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36353 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758681AbXGEQnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:43:35 -0400
Date: Thu, 5 Jul 2007 17:43:34 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Josh Triplett <josh@freedesktop.org>
Cc: linux-sparse@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
Message-ID: <20070705164334.GM21478@ftp.linux.org.uk>
References: <20070705093528.GK21478@ftp.linux.org.uk> <468D1003.1050901@freedesktop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468D1003.1050901@freedesktop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 08:36:35AM -0700, Josh Triplett wrote:
> Wow.  Insane.  So these all declare the same type:
> __attribute__((foo)) T *v;
> T __attribute__((foo)) *v;
> T *__attribute__((foo)) v;
> ?  Specifically, they point to a foo-T, for convenient shooting?

They all give you foo-pointer-to-T.  
	T (__attribute__((foo)) *v);
would give pointer-to-foo-T.

> context also represents a qualifier; the position of the qualifier should
> determine things like whether you want to enforce the context when you access
> a pointer or dereference a pointer.

Since __context__ is (sparse-only) keyword, we are not constrained by
anything anyway.
 
> > Frankly, I would rather add a new primitive (__qualifier__) mirroring the
> > __attribute__, but acting like real qualifiers do.  And switched the
> > noderef et.al. to it.
> 
> Something like that sounds vaguely reasonable.  It should allow the same set
> of attributes, and just change what they apply to.  To use your example,
> T __qualifier__((foo)) *v;
> and
> T (__attribute__((foo)) *v);
> would mean the same thing.

Yup, except that it would not accept storage-class-like attributes (e.g.
always_inline).  And yes, __qualifier__((context(...))) probably might
be a replacement for __context__, to reduce the number of primitives.
