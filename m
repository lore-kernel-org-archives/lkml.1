Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYHSHdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYHSHdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYHSHcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:32:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbYHSHcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:32:53 -0400
Date: Tue, 19 Aug 2008 00:32:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cred: remove const qualifiers
Message-Id: <20080819003211.ba6b0ac5.akpm@linux-foundation.org>
In-Reply-To: <12514.1218365916@redhat.com>
References: <1218322941.24441.11.camel@brick>
	<12514.1218365916@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 11:58:36 +0100 David Howells <dhowells@redhat.com> wrote:

> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > get_new_cred clearly writes through the pointer, so const isn't
> > appropriate.  Sparse warns thusly:
> > 
> > include/linux/cred.h: In function ___get_cred___:
> > include/linux/cred.h:181: warning: passing argument 1 of ___get_new_cred___ discards qualifiers from pointer target type
> 
> Sparse is wrong in this instance, it failed to note the cast.  I know what I'm
> doing.

Nobody who reads the code will know what you were doing - the code
looks plain wrong.

> > -static inline const struct cred *get_cred(const struct cred *cred)
> > +static inline struct cred *get_cred(struct cred *cred)
> 
> That will break the compilation.  Please don't do that.
> 
> The point of my use of const in this instance is to stop people from trying to
> modify committed credentials directly, especially current->cred.  But we still
> have to be able to take a reference to it.  Unfortunately, C does not provide
> the necessary tools to do what I want.
> 
> Eventually, we can probably ditch the const marks on the pointers but not yet.

That information should have been included in a code comment.
