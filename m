Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZGDQ7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZGDQ7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 12:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZGDQ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 12:59:40 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:50867 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZGDQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 12:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=k3B7/SGX4uOTqTrHZfkEvv8xIKPfe8WNVbutJ7vZYx41lxyODO15D6DZAR2FXYnSIJ
         kdFGaLS+rshFOjOIablsFU8+F+LVUBKPlO6SzTHMcYou/O4BJwC4n43R77DX8aL09ano
         Hf4wBU4ubXeeFS8uEIKGSq+y58YzXcztdKJC8=
MIME-Version: 1.0
Date: Sat, 4 Jul 2009 09:59:41 -0700
Message-ID: <46b8a8850907040959q502968bcx8bc4e20c907f9c57@mail.gmail.com>
Subject: discard/UNMAP support: prepare_discard_fn does not pass enough info 
	even in 2.6.31rc1
From: Richard Sharpe <realrichardsharpe@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to get BLKDICARD/unmap support working in SCST, and while
I have some code that works if I directly submit requests to
scst_local, things _seem_ broken above me.

There has been some support for BLKDISCARD requests for a number of
kernel releases already (starting about 2.6.28), but for UNMAP, and
probably any real support for DISCARD, we need to know the starting
sector and the range of sectors being discarded. However, at the point
at prepare_unmap_fn is called, that info has not been placed in the
request. Probably the simplest change would be to pass the bio to
prepare_discard_fn as well.

Matthew Wilcox published a patch that looks like it does close to the
right things here: http://lkml.org/lkml/2008/11/23/81

This passes the bio to prepare_discard_fn and has implemented a
discard function in sd.c so I do not have to do that work in my LLD,
but it seems to target an earlier version of the spec. I am working
with 08-149r9-3.pdf off of the T10 site.

Who should I contact about getting these changes merged or proposing a
different set of changes?

-- 
Regards,
Richard Sharpe
