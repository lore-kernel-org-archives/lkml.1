Return-Path: <linux-kernel-owner+w=401wt.eu-S1762448AbYBFWze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762448AbYBFWze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760374AbYBFWzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:55:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51039 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760364AbYBFWzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:55:10 -0500
Date: Wed, 6 Feb 2008 14:54:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
Message-ID: <20080206145439.4ef971f2@laptopd505.fenrus.org>
In-Reply-To: <20080206143457.03e8741d.akpm@linux-foundation.org>
References: <47AA3126.8090102@redhat.com>
	<20080206143457.03e8741d.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 14:34:57 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Does the patch actually help?  I mean, if a() calls b() and both use N
> bytes of locals, our worst-case stack usage remains ~2N whether or
> not b() was inlined in a()?  In fact, uninlining makes things a
> little worse due to callframe stuff.

it gets interesting at the three-way..
if a() calls b() and then calls c(), and they all use N,
the total usage is now 3N not 2N.

(although current gcc is already somewhat smarter about this, and 3N might actually be 2N for some cases)
