Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbZAQUeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbZAQUeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZAQUeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:34:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43543 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbZAQUeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:34:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090117082623.GB24905@elte.hu>
References: <20090117082623.GB24905@elte.hu> <20090115181612.GA27762@elte.hu> <16916.1232172471@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Michael LeMay <mdlemay@epoch.ncsc.mil>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [slab corruption] BUG key_jar: Poison overwritten
Date: Sat, 17 Jan 2009 20:33:22 +0000
Message-ID: <31147.1232224402@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> The problem was not reproducible - i tried the same config once more and 
> it didnt produce the bug. (this system has no known hardware flukes)

Having thought about it some more, we can't necessarily pin the blame on the
key management code.  I think it more likely due to the previous owner of the
page as it's the guard poisoning that got corrupted, not the allocated key
struct.  The problem is we don't know who that was.  I wonder if it's
practical to store a recent history of page allocs and releases in a circular
buffer.

David
