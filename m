Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYA1NOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYA1NOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYA1NOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:14:00 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:54344 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbYA1NN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:13:58 -0500
Message-Id: <01cb01c861af$8515d230$41a8400a@bsd.tnes.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Theodore Tso" <tytso@MIT.EDU>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
       <linux-ext4@vger.kernel.org>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
Subject: Re: [RFC] ext3 freeze feature
Date: Mon, 28 Jan 2008 22:13:05 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> What you *could* do is to start putting processes to sleep if they
> attempt to write to the frozen filesystem, and then detect the
> deadlock case where the process holding the file descriptor used to
> freeze the filesystem gets frozen because it attempted to write to the
> filesystem --- at which point it gets some kind of signal (which
> defaults to killing the process), and the filesystem is unfrozen and
> as part of the unfreeze you wake up all of the processes that were put
> to sleep for touching the frozen filesystem.

I don't think close() usually writes to journal and the deadlock occurs.
Is there the special case which close() writes to journal in case of
getting signal?

Cheers, Takashi 

