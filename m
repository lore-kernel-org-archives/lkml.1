Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbZCXWMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbZCXWMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCXWMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:12:06 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:53366 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771AbZCXWME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:12:04 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net 576B11B3843
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: fastboot: unpacking initramfs faster
To: Andreas Robinson <andr345@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 24 Mar 2009 23:11:56 +0100
References: <cj9yI-540-17@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LmEqj-0001SN-6Y@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Robinson <andr345@gmail.com> wrote:

> I tried running the initramfs unpacking asynchronously (and earlier) but
> ran into a curious problem: The parent thread stalled until
> decompression was done. I don't know why - I made sure that the two
> threads ran on different cores. Perhaps the parent was cache starved.

I could not stall my system by gzip</dev/urandom>/dev/null.
Maybe you accidentally used vfork?

> I then looked at multithreaded decompression and found that neither gzip
> files nor deflate streams provide enough information (eg block lengths)
> to let you share the decompression among threads.
> 
> It can be done of course, but obviously not without modifying file
> formats and userspace tools.
> 
> (Thoughts of snowballs and hell presented themselves at this point.)

Why not make a new set? http://7eggert.dyndns.org:8080/l/bgz.tar.gz

