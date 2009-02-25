Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZBYMlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZBYMlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZBYMlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:41:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35875 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZBYMlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:41:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090223204041.GA31626@us.ibm.com>
References: <20090223204041.GA31626@us.ibm.com> <20090109225313.GB15599@us.ibm.com> <20090109225208.GA15252@us.ibm.com> <5296.1234522990@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 4/4] keys: make procfiles per-user-namespace
Date: Wed, 25 Feb 2009 12:41:04 +0000
Message-ID: <16728.1235565664@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> > Hmmm...  I wonder if we can do better by making the file position indicate
> > the key ID rather than being a count of the number of keys read.  It might
> > make this cleaner.
> 
> file position?  as in the result of lseek(fd, 0, SEEK_CUR)?
> 
> I don't understand what you're suggesting.

Currently the file position on /proc/keys indicates the number of keys that
have been read.  It is incremented by 1 for each key read, irrespective of the
length of the line that was read for that key.

We could, instead, map file positions to key IDs, and skip any file positions
that don't actually map to an extant key.

David
