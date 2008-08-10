Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYHJK6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYHJK6s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 06:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYHJK6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 06:58:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYHJK6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 06:58:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1218322941.24441.11.camel@brick>
References: <1218322941.24441.11.camel@brick>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cred: remove const qualifiers
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Date: Sun, 10 Aug 2008 11:58:36 +0100
Message-ID: <12514.1218365916@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> get_new_cred clearly writes through the pointer, so const isn't
> appropriate.  Sparse warns thusly:
> 
> include/linux/cred.h: In function ‘get_cred’:
> include/linux/cred.h:181: warning: passing argument 1 of ‘get_new_cred’ discards qualifiers from pointer target type

Sparse is wrong in this instance, it failed to note the cast.  I know what I'm
doing.

> -static inline const struct cred *get_cred(const struct cred *cred)
> +static inline struct cred *get_cred(struct cred *cred)

That will break the compilation.  Please don't do that.

The point of my use of const in this instance is to stop people from trying to
modify committed credentials directly, especially current->cred.  But we still
have to be able to take a reference to it.  Unfortunately, C does not provide
the necessary tools to do what I want.

Eventually, we can probably ditch the const marks on the pointers but not yet.

David
