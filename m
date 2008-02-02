Return-Path: <linux-kernel-owner+w=401wt.eu-S1763875AbYBBPZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763875AbYBBPZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbYBBPZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:25:13 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43866 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbYBBPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:25:11 -0500
Subject: Re: [PATCH] Allow NBD to be used locally
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Paul.Clements@steeleye.com, nbd-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080202112336.GB5362@elf.ucw.cz>
References: <1201872332265-git-send-email-Laurent.Vivier@bull.net>
	 <20080202112336.GB5362@elf.ucw.cz>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Sat, 02 Feb 2008 16:26:11 +0100
Message-Id: <1201965971.4591.13.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le samedi 02 février 2008 à 12:23 +0100, Pavel Machek a écrit :
> On Fri 2008-02-01 14:25:32, Laurent Vivier wrote:
> > This patch allows Network Block Device to be mounted locally.
> 
> What is local nbd good for? Use loop instead...

It allows to write userlevel block device. In my case, I can mount disk
image of Qemu (qcow2, vmdk, ...).

> > It creates a kthread to avoid the deadlock described in NBD tools documentation.
> > So, if nbd-client hangs waiting pages, the kblockd thread can continue its
> > work and free pages.
> 
> Hmm, and if there are no other pages that can be freed? Unlikely, but
> can happen AFAICT.

Correct. The patch improves the NBD behavior even if it is not perfect.
And I think if no other page can be freed your system is in very bad
move ;-)

Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
  "La perfection est atteinte non quand il ne reste rien à
ajouter mais quand il ne reste rien à enlever." Saint Exupéry

