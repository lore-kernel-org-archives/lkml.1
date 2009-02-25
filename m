Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbZBYVD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbZBYVD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbZBYVDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:03:50 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:40771 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbZBYVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:03:49 -0500
Date: Wed, 25 Feb 2009 15:03:36 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 4/4] keys: make procfiles per-user-namespace
Message-ID: <20090225210336.GA20086@us.ibm.com>
References: <20090223204041.GA31626@us.ibm.com> <20090109225313.GB15599@us.ibm.com> <20090109225208.GA15252@us.ibm.com> <5296.1234522990@redhat.com> <16728.1235565664@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16728.1235565664@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > > Hmmm...  I wonder if we can do better by making the file position indicate
> > > the key ID rather than being a count of the number of keys read.  It might
> > > make this cleaner.
> > 
> > file position?  as in the result of lseek(fd, 0, SEEK_CUR)?
> > 
> > I don't understand what you're suggesting.
> 
> Currently the file position on /proc/keys indicates the number of keys that
> have been read.  It is incremented by 1 for each key read, irrespective of the
> length of the line that was read for that key.
> 
> We could, instead, map file positions to key IDs, and skip any file positions
> that don't actually map to an extant key.

So you want users to be able to mmap the file and lseek to a particular
spot?  Is that bc you have users with so many keys that
	grep keyid /proc/keys
becomes slow?

Or am I still misunderstanding?

Meanwhile, do you have any objections to these 4 patches?  :)

thanks,
-serge
