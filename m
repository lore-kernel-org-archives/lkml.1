Return-Path: <linux-kernel-owner+w=401wt.eu-S966511AbXEGUTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966511AbXEGUTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966496AbXEGUTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:19:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33002 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966308AbXEGUTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:19:20 -0400
Date: Mon, 7 May 2007 21:23:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: righiandr@users.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] VM: per-user overcommit policy
Message-ID: <20070507212322.6d60210b@the-village.bc.nu>
In-Reply-To: <463F764E.5050009@users.sourceforge.net>
References: <463F764E.5050009@users.sourceforge.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - allow uid=1001 and uid=1002 (common users) to allocate memory only if the
>   total committed space is below the 50% of the physical RAM + the size of
>   swap:
> root@host # echo 1001:2:50 > /proc/overcommit_uid
> root@host # echo 1002:2:50 > /proc/overcommit_uid

There are some fundamental problems with this model - the moment you mix
strict overcommit with anything else it ceases to be a strict overcommit
and you might as well use existing overcommit rules for most stuff

The other thing you are sort of faking is per user resource management -
which is a subset of per group of users resource management which is
useful - eg "students can't hog the machine"

I don't see that this is the right approach compared with the container
work and openvz work that is currently active and far more flexible.

Alan
