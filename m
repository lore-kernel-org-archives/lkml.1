Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYJHH0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYJHH0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYJHH0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:26:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:53081 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYJHH0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cwZ3fWAgScrL2W+GJMxDWLbxxjpuNh3Z0ccaFShHzYIHZQfSOIjztjgBjljsfaX5XI
         zHocq5du0wVmDBYvE1COB19i12JCBUQk5XtQsRPx/Y/y6QUY1JYWra1CayJLP8eem/Pi
         f+rfMWbhQpKidwbl8b6y1M8+5d35a7/5U6Og0=
Subject: FRV/ARM unaligned access question
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>, David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 00:26:13 -0700
Message-Id: <1223450773.8195.80.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, Russell,

I noticed that frv/arm are the only two arches that currently use open-coded
byteshifting routines for both the cpu endianness and the other endianness
whereas just about all the other arches use a packed-struct version for the
cpu-endian and then the byteshifting versions (lifted from arm) for the other
endianness.

For frv, this was due to the consolidation of unaligned access helpers which
removed the assembly version.  For ARM, I think it was done this way as the
kernel could be compiled for either endianness and so it was just easiest to
always have the byteshifting versions around.  

>From the comments in the ARM version, time was spent to make sure the byteshifting
helpers used a small amount or registers.  Was there a known problem with the
packed-struct implementation on ARM that made you choose to use byte-shifting
or was it just done this way to more easily support compiling for different
endianness?

If there isn't an issue I'm missing, could ARM/FRV move over to the packed-struct
version?

Cheers,

Harvey




