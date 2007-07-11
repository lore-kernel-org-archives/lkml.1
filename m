Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbXGKJoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbXGKJoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbXGKJoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:44:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:21667 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbXGKJoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:44:11 -0400
Date: Wed, 11 Jul 2007 11:44:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: avoiding rejects
In-Reply-To: <20070710124422.a52b0458.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707111141330.11053@fbirervta.pbzchgretzou.qr>
References: <20070710124422.a52b0458.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 10 2007 12:44, Andrew Morton wrote:
>
>There are many situations where patching the kernel involves adding a new
>item to a list, such as:
>
>- adding a makefile line
>- adding a new #include
>- adding a new Kconfig entry
>- adding a new PCI ID
>- adding a record to feature-removal.txt
>- adding a new sysctl table entry
>- etc
>
>Of course, everyone just sticks the new entry at the end of the existing
>entries.  This strategy carefully maximises the opportunity for patch
>rejects and leads to unhappiness.
>
>Most of these lists are unordered anyway, so inserting the new item at a
>randomly-chosen position is a better approach than just appending it.

As for Makefiles: Sort the list lexicographically. Let the submitter put
it into the right spot.
Example: net/netfilter/Makefile.
There are lots of obj-$(CONFIG_NETFILTER_XT_MATCH_xyz) += xt_xyz.o for example,
which can be sorted without disturbing required linking order or whatnot
(for some directories this seems important).
Benefit: Less rejects of course (not as much as a truly random insert,
but still less than appending) _and_ a sorted list.


	Jan
-- 
