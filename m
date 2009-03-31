Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbZCaV1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbZCaV1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZCaV1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:27:45 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:34288 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858AbZCaV1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:27:44 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 9DB813CA5BF
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in 	UBIFS)
To: Pavel Machek <pavel@ucw.cz>, Artem Bityutskiy <dedekind@yandex.ru>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Tue, 31 Mar 2009 23:27:33 +0200
References: <ckjPq-2Dl-15@gated-at.bofh.it> <cl2jy-65z-1@gated-at.bofh.it> <cl2CZ-6q2-21@gated-at.bofh.it> <cl2N9-6Bj-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LolUc-0003kM-FU@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> My proposal is
> 
> rename() stays.
> 
> replace(src, bar) is rename that ensures that bar will contain valid
> data after powerfail.

This can be done using implicit logic:

->E.g. on close(), mark inodes without being sync()ed as poisoned.
(I can think of more sophisticated logic, but ...)
->On completing the inode with the delayed allocations, unpoison it.
->Don't commit rename()s if the corresponding inode is poisoned.

Et Voila, everything replace is supposed to guarantee is guaranteed.

