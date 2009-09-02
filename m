Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZIBWpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZIBWpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZIBWpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:45:38 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33522
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbZIBWph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:45:37 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3: document conditions when reliable operation is possible)
Date: Wed, 2 Sep 2009 17:45:34 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: Ric Wheeler <rwheeler@redhat.com>, david@lang.hm,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
References: <20090826001645.GN4300@elf.ucw.cz> <4A9910D5.4060208@redhat.com> <20090902201210.GC1840@ucw.cz>
In-Reply-To: <20090902201210.GC1840@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909021745.36687.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 September 2009 15:12:10 Pavel Machek wrote:
> > (2) RAID5 protects you against a single failure and your test case
> > purposely injects a double failure.
>
> Most people would be surprised that press of reset button is 'failure'
> in this context.

Apparently because most people haven't read Documentation/md.txt:

  Boot time assembly of degraded/dirty arrays
  -------------------------------------------

  If a raid5 or raid6 array is both dirty and degraded, it could have
  undetectable data corruption.  This is because the fact that it is
  'dirty' means that the parity cannot be trusted, and the fact that it
  is degraded means that some datablocks are missing and cannot reliably
  be reconstructed (due to no parity).

And so on for several more paragraphs.  Perhaps the documentation needs to be 
extended to note that "journaling will not help here, because the lost data 
blocks render entire stripes unreconstructable"...

Hmmm, I'll take a stab at it.  (I'm not addressing the raid 0 issues brought 
up elsewhere in this thread because I don't comfortably understand the current 
state of play...)

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
