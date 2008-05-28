Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbYE1OKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbYE1OKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYE1OJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:09:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbYE1OJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:09:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2874.1211980355@redhat.com>
References: <2874.1211980355@redhat.com> <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
Cc: dhowells@redhat.com, Pekka J Enberg <penberg@cs.helsinki.fi>,
       clameter@sgi.com, mpm@selenic.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 28 May 2008 15:09:18 +0100
Message-ID: <24762.1211983758@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Works for SLAB and SLUB.  SLOB breaks well before getting to anything these
> patches affect.

Okay...  The problem with SLOB is that it can return large objects (8Kb in this
case) that aren't 8-byte aligned.  This screws up FRV as it expects to be able
to use load and store-double instructions, which fault if they don't get
8-byte (double register) alignment.

David
