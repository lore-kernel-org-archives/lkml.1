Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbYJFKwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbYJFKwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYJFKw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:52:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbYJFKw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:52:29 -0400
Date: Mon, 6 Oct 2008 06:52:25 -0400
From: Alan Cox <alan@redhat.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/76] tty: Add a kref count
Message-ID: <20081006105225.GA9606@shell.devel.redhat.com>
References: <20081005160231.1997.10462.stgit@localhost.localdomain> <20081005160811.1997.59217.stgit@localhost.localdomain> <20081006102037.GB29198@hawkmoon.kerlabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006102037.GB29198@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.4.2.2i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 12:20:37PM +0200, Louis Rilling wrote:
> 
> I'm a bit puzzled by this 'tty_kref_put(p->signal->tty)'. AFAICS, this is a noop
> since we are not in the CLONE_THREAD case and hence p->signal->tty == NULL.

When I first did it I was seeing non NULL values, but since then I've added
the initialisation

> So, is it to make the code look more consistent? If so, is it worth adding extra
> code and cycles for this (I doubt that gcc is able to optimize this away)? What
> kind of future changes should this code protect against?

I'll take a look, you may well be right, and if so it can become a WARN_ON()
instead.
