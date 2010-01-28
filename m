Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855Ab0A1Xyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0A1Xyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229Ab0A1Xyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:54:47 -0500
Received: from mail.anarazel.de ([217.115.131.40]:60956 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab0A1Xyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:54:46 -0500
From: Andres Freund <andres@anarazel.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: add fincore(2) (mincore(2) for file descriptors)
Date: Fri, 29 Jan 2010 00:54:40 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc5-andres-00243-g6ea299e; KDE/4.3.95; x86_64; ; )
Cc: Steve VanDeBogart <vandebo-lkml@nerdbox.net>,
       Chris Frost <frost@cs.ucla.edu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Benny Halevy <bhalevy@panasas.com>, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20100120215712.GO27212@frostnet.net> <alpine.DEB.1.00.1001272319530.2909@abydos.NerdBox.Net> <20100128002313.2b94344e.akpm@linux-foundation.org>
In-Reply-To: <20100128002313.2b94344e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001290054.42246.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 January 2010 09:23:13 Andrew Morton wrote:
> On Wed, 27 Jan 2010 23:42:35 -0800 (PST) Steve VanDeBogart <vandebo-
lkml@NerdBox.Net> wrote:
> > > Is it likely that these changes to SQLite and Gimp would be merged into
> > > the upstream applications?
> > 
> > Changes to the GIMP fit nicely into the code structure, so it's feasible
> > to push this kind of optimization upstream.  The changes in SQLite are
> > a bit more focused on the benchmark, but a more general approach is not
> > conceptually difficult.  SQLite may not want the added complexity, but
> > other database may be interested in the performance improvement.
> > 
> > Of course, these kernel changes are needed before any application can
> > optimize its IO as we did with libprefetch.
> That didn't really answer my question.
> If there's someone signed up and motivated to do the hard work of
> getting these changes integrated into the upstream applications then
> that makes us more interested.  If, however it was some weekend
> proof-of-concept hack which shortly dies an instadeath then...  meh,
> not so much.
There is somebody working on a POC contrib module for postgres to deliver 
better cost estimates using mincore - as postgres doesnt use mmap itself 
something like fincore would be rather nice there.

(While currently it would be contrib module the plan is to be able too hook it 
into it without modifications to core pg code)

Andres
