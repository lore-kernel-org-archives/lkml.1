Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYAIJMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYAIJMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYAIJMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:12:06 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31580
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbYAIJMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:12:03 -0500
Message-Id: <47849E00.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 09 Jan 2008 09:12:16 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <mingo@elte.hu>, <pq@iki.fi>, <torvalds@linux-foundation.org>,
       "Dave Airlie" <airlied@linux.ie>, <hch@lst.de>, <ak@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
	achitectures and kill notifier cruft"
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
 <20080108190611.3b9c0760.akpm@linux-foundation.org>
 <alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie>
 <20080108192951.a4dc394f.akpm@linux-foundation.org>
In-Reply-To: <20080108192951.a4dc394f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartC4E20AE0.6__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartC4E20AE0.6__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>That change has been in the mainline tree for nearly three months.  All
>these affected parties have left it until the eve of 2.6.24 to actually
>tell us about it.  This is causing me sympathy problems :(

Not true - I complained about this on Dec 3rd (attached), with the result =
of
not getting a response from anyone but Andi (agreeing to restore these
notifiers).

Jan

--=__PartC4E20AE0.6__=
Content-Type: message/rfc822

Date: Mon, 03 Dec 2007 13:31:07 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <akpm@linux-foundation.org>,<torvalds@linux-foundation.org>,
	<hch@lst.de>
Cc: <ananth@in.ibm.com>,<prasanna@in.ibm.com>,
	<anil.s.keshavamurthy@intel.com>, <ak@suse.de>,
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: x86: optimize page faults like all other achitectures and
	kill notifier cruft
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Ever since I started to try to get at least some fundamental infrastructure=

pieces merged for using NLKD on Linux I was told that direct calls out of
exception handlers for the sake of an individual (and perhaps even small)
sub-system is undesirable.

Making the exception notifiers report the right (correct) information =
(and,
specific to x86, ensuring they get called in the right place) was one of =
the
fundamental things, and just now I see that this is being reverted for (in
my eyes) no good reason: Instead of adding direct calls to x86, all the
other architectures should have followed the notifier model in order for
the infrastructure to be usable by external components, especially if
these aren't allowed into the kernel.

Am I to conclude that replacing direct calls elsewhere in the tree (in =
order
to e.g. avoid all kinds of small sub-components leaving their footprint in
core files like kernel/fork.c) is no longer a desirable goal, thereby =
making
it almost impossible to ever host a kernel debugger *without* having to
patch core files.

Thanks, Jan


--=__PartC4E20AE0.6__=--
