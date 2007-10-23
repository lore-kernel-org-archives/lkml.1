Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbXJWHhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbXJWHhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXJWHhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:37:06 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:42706 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbXJWHhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:37:05 -0400
To: akpm@linux-foundation.org
CC: riel@redhat.com, linux-kernel@vger.kernel.org, xemul@openvz.org,
       raven@themaw.net
In-reply-to: <20071022171624.0c00f8da.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 22 Oct 2007 17:16:24 -0700)
Subject: Re: futex strangeness in 2.6.23-mm1/UML
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu>
	<20071022145321.195d929b@bree.surriel.com>
	<E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu>
	<20071022172926.03ca122a@bree.surriel.com>
	<20071022200742.6f3acbb2@bree.surriel.com> <20071022171624.0c00f8da.akpm@linux-foundation.org>
Message-Id: <E1IkEJP-0004Qp-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Oct 2007 09:36:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess we can debug it in the old-fashioned ways.  The first of which is
> to palm the problem off on Pavel ;)
> 
> I don't recall seeing a simple step-by-step way by which others can
> reproduce this?

My method is this:

- enable CONFIG_FUSE_FS
- compile fuse from CVS:
 cvs -d:pserver:anonymous@fuse.cvs.sourceforge.net:/cvsroot/fuse co -P fuse
 cd fuse
 ./makeconf.sh
 ./configure
 make
 make -C test

- in one shell:
 mkdir /tmp/fuse
 example/fusexmp_fh -d /tmp/fuse

- in another shell:
 mkdir /tmp/test
 test/test /tmp/fuse/tmp/test

The result is normally a completed run with "1 tests failed".  On
2.6.23-mm1, it just hangs after the first test.

I've only tried under UML, but since Rick is seeing it on real HW, I
guess this method may work there as well.

Miklos
