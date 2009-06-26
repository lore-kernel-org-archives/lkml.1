Return-Path: <linux-kernel-owner+w=401wt.eu-S1760399AbZFZMwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399AbZFZMwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbZFZMwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:52:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36997 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429AbZFZMwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:52:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090625014520.449.98923.stgit@dev.haskins.net>
References: <20090625014520.449.98923.stgit@dev.haskins.net>
To: Gregory Haskins <ghaskins@novell.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] slow-work: add (module*)work->owner to fix races with module clients
Date: Fri, 26 Jun 2009 13:52:16 +0100
Message-ID: <17232.1246020736@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins <ghaskins@novell.com> wrote:

> The slow_work facility was designed to use reference counting instead of
> barriers for synchronization.  The reference counting mechanism is
> implemented as a vtable op (->get_ref, ->put_ref) callback.  This is
> problematic for module use of the slow_work facility because it is
> impossible to synchronize against the .text installed in the callbacks:
> There is no way to ensure that the slow-work threads have completely
> exited the .text in question and rmmod may yank it out from under the
> slow_work thread.

This seems reasonable.  I'll get round to testing it if I can find the OOM bug
that's nobbling by test machine.

David
