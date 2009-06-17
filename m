Return-Path: <linux-kernel-owner+w=401wt.eu-S1764314AbZFQFSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764314AbZFQFSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 01:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZFQFSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 01:18:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39251 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbZFQFSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 01:18:35 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nick Piggin <npiggin@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <alpine.LFD.2.01.0906161231020.3282@localhost.localdomain>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>
	 <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>
	 <1245101567.12400.38.camel@pasglop>
	 <alpine.DEB.1.10.0906161104480.26093@gentwo.org>
	 <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain>
	 <alpine.DEB.1.10.0906161522370.29941@gentwo.org>
	 <alpine.LFD.2.01.0906161231020.3282@localhost.localdomain>
Date: Wed, 17 Jun 2009 08:18:36 +0300
Message-Id: <1245215916.5604.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, 2009-06-16 at 12:33 -0700, Linus Torvalds wrote:
> I mean that there should never be any _need_ for dynamically querying 
> whether slab is available or not. Nothing should ever do it, because we 
> should strive for slab being available so early that anything that happens 
> before it _knows_ that it is special case code (eg "set up initial page 
> tables") and would never have any reason what-so-ever for even 
> conditionally asking "should I use slab".

So how does the page allocator fit in this new scheme of things? I have
been looking at doing the cleanups you and Christoph suggested and it
seems to me we need a 'system_gfp_mask' that's respected by basically
everyone, including __might_sleep() and other debugging functions.

If we want to keep the masking within the slab allocator, we need to
make sure there are two sets of APIs: one for slab and one for the page
allocator. Otherwise we end up masking in the debugging checks but not
in page_alloc().

			Pekka

