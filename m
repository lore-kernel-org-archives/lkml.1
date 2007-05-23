Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbXEWWYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbXEWWYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbXEWWYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:24:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40671 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759031AbXEWWYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:24:02 -0400
Date: Wed, 23 May 2007 15:24:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <4654AC94.6080601@googlemail.com>
Message-ID: <Pine.LNX.4.64.0705231522060.22666@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
 <4654AC94.6080601@googlemail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1023810841-1179959041=:22666"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1023810841-1179959041=:22666
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 23 May 2007, Michal Piotrowski wrote:

> [   19.096577] Real Time Clock Driver v1.12ac
> [   21.650315] *** SLUB kmalloc-8: Redzone Active@0xc90f6d20 slab 0xc528c=
530
> [   21.657365]     offset=3D3360 flags=3D0x400000c3 inuse=3D61 freelist=
=3D0xc90f6d58
> [   21.664349]   Bytes b4 0xc90f6d10:  00 00 00 00 00 00 00 00 5a 5a 5a 5=
a 5a 5a 5a 5a ........ZZZZZZZZ
> [   21.674305]     Object 0xc90f6d20:  31 30 31 39 2e 30 30 35           =
              1019.005       =20
> [   21.684259]    Redzone 0xc90f6d28:  00 cc cc cc                       =
              .=FF=FF=FF=FF=FF=FF           =20

Ok. We are writing a string of length 8 to an object allocated via=20
kmalloc(8). A string of 8 bytes needs a 0x00 at the end though. This makes=
=20
it 9 bytes. The kmalloc should have been for 9 bytes!

---1700579579-1023810841-1179959041=:22666--
