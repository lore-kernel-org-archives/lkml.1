Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbZBKT05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbZBKT05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZBKT0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:26:46 -0500
Received: from 30.mail-out.ovh.net ([213.186.62.213]:41543 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755969AbZBKT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:26:45 -0500
From: "David CHAMPELOVIER" <david@champelovier.com>
To: <linux-kernel@vger.kernel.org>
Subject: "heuristic overcommit" and fork()
Date: Wed, 11 Feb 2009 20:26:32 +0100
Message-ID: <ED3886372DB5491AAA799709DBA78F6F@david>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6838
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Thread-Index: AcmMfqRrVSXw11ChQm2dkTKbl7QN+g==
Importance: Normal
X-Ovh-Tracer-Id: 2769150821079659544
X-Ovh-Remote: 82.122.4.26 (agrenoble-152-1-5-26.w82-122.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.500003/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, I was unable to fork() a 38 GB process on a system with 64 GB RAM
and no swap.
Having a look at the kernel source, I surprisingly found that in "heuristic
overcommit" mode, fork() always checks that there is enough memory to
duplicate process memory.

As far as I know, overcommit was introduced in the kernel for several
reasons, and fork() was one of them, since applications often exec() just
after fork(). I know fork() is not the most judicious choice in this case,
but well, this is the way many applications are written.

Moreover, I can read in the proc man page that in "heuristic overcommit
mode", "obvious overcommits of address space are refused". I do not think
fork() is an obvious overcommit, that's why I would expect fork() to be
always accepted in this mode.

So, is there a reason why fork() checks for available memory in "heuristic
mode" ?

Thanks in advance.

--
David Champelovier

