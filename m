Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZDWRYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZDWRYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZDWRX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:23:56 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57805 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZDWRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:23:55 -0400
Date: Thu, 23 Apr 2009 18:23:53 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Valerie Aurora Henson <vaurora@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423172338.GB9399@shareable.org>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423160426.GF8476@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423160426.GF8476@shell>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valerie Aurora Henson wrote:
> All that being said, I'd be thrilled to have fine-grained fsync().

Me too.

Ted raises a very good point that fine-grained fsync will not be used
by most applications, and they expect good behaviour automatically on
crashes without it (which is imho reasonable to ask for).

A lot of apps and scripts go wrong if the disk is full too.  I've seen
more truncated files from that than from system crashes.

I think both events are so rare that most of the time nobody cares.
They're corner cases.  Let's face it, nearly every shell script which
edits files in a specific order (see also "make") will see
inconsistencies following a system crashes.

But the thing is: certain core packages where reliability is a
requirement will use whatever mechanisms are available.  Every mail
transport and database engine seems to get this right - or try their
best given limitations of the OS - it's their job to care.  Those are
widely used by other apps.

Let's face it, like most other authors, if powerfail-robustness were
that important to us on linux-kernel, barriers would never have been
off by default on ext3, and fsync would always have emitted barriers.

The thing is: you _can_ expect certain core packages, used by a large
number of apps, to make use of whatever features work well.  Make
those reliable and you've solved a big chunk of the problem.  Make the
core packages able to perform well at the same time, and a few more
apps will use them instead of their own implementations.

-- Jamie
