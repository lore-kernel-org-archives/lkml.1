Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYCKOba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYCKOba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYCKObU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:31:20 -0400
Received: from mx12.go2.pl ([193.17.41.142]:57518 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbYCKObT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:31:19 -0400
Message-ID: <47D697B5.80400@o2.pl>
Date: Tue, 11 Mar 2008 15:31:17 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 3.0a1pre (X11/2008030620)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <20080310092213.7ba878b3@core> <200803102050.40567.phillips@phunq.net> <47D689DF.10408@o2.pl>
In-Reply-To: <47D689DF.10408@o2.pl>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artur Skawina wrote:
> Now, if you add snapshots to the backing store it suddenly becomes much
> more interesting -- you no longer need to put so much trust in all the
> hw. Should the device fail for whatever reason then you just rollback to
> the last good snapshot upon restart. No corrupted fs, no fsck; you lose
> some newly written data (that you couldn't recover w/o a snapshot anyway),
> but can trust the rest of it (assuming you trust the fs and storage hw,
> but that's no different then w/o ramback).

or you could keep two devices as backing store, use one and switch to the
other when the fs is consistent. This could as simple as noticing zero
dirty data in the ramdisk or, if something is constantly writing to it,
reacting periodically to some barrier (needs cow/doublebuffering in order
to not throttle the writer, but you already do this). Means ramdisk can
be as large as 1/2 the stable storage and a bit more i/o (resyncing after
switch to the other device), but gives you two copies of the data; one
stable and one that can be used to recover newer data should you need to.

artur
