Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZIMPPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZIMPPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 11:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZIMPP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 11:15:28 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:55224 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZIMPP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 11:15:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=f9z1QkpnI5iDcaqPogx/MWaiat98p/uzCmVyQUbY5uCX4+DsgFfqupP5Krm8nW4kLS
         gjSH2UI31XMHS+aPCakegraIQ6Kq0kpHzgAhl+Ky89dpbXA87d0tswRdZ90V9fge8/az
         MY8VCTK7C6n44tPKBZW8EOwLlP3fL8Za8YnnI=
MIME-Version: 1.0
Date: Sun, 13 Sep 2009 11:15:30 -0400
Message-ID: <f7848160909130815l3e768a30n3b28808bbe5c254b@mail.gmail.com>
Subject: Trace event testing time - 3s to 41s
From: Parag Warudkar <parag.lkml@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhere between -rc9 and yesterday's git, my desktop went from using
3s worth of trace event testing time to 41s !

It looks like we not only added a whole bunch of tracing points but
also are doing the tests twice post -rc9 - the addition being testing
with function tracer.

grep "Testing event" dmesg.31rc9 |wc -l
100

grep "Testing event" dmesg.31git |wc -l
1172

While one could get away with "don't enable that config option then"
response, for testing kernels daily this sounds like it is going to be
very annoying as it adds a considerable boot lag.

So I was thinking could we move this testing to a kthread with idle
priority or something - may be disabling tracing until those tests are
finished, if that sort of thing is necessary?
Or does it need to happen synchronous to booting?

Thanks

Parag
