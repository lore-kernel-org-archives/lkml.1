Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYIQPjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYIQPjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYIQPjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:39:05 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:33478 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbYIQPjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:39:04 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] dm-snapshot: poor copy-on-write performance due to I/O reordering
To: Kazuo Ito <ito.kazuo@oss.ntt.co.jp>, dm-devel@redhat.com, jblunck@suse.de,
       kjamieson@bycast.com, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 17 Sep 2008 17:47:50 +0200
References: <bd0gX-4ma-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KfzFv-00041e-8A@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kazuo Ito <ito.kazuo@oss.ntt.co.jp> wrote:

> Write throughput to LVM snapshot origin volume is an order
> of magnitude slower than those to LV without snapshots or
> snapshot target volumes, especially in the case of sequential
> writes with O_SYNC on.
> 
> The following patch originally written by Kevin Jamieson and
> Jan Blunck and slightly modified for the current RCs by myself
> tries to improve the performance by modifying the behaviour
> of kcopyd, so that it pushes back an I/O job to the head of
> the job queue instead of the tail as process_jobs() currently
> does when it has to wait for free pages. This way, write
> requests aren't shuffled to cause extra seeks.

Did you check for starvation problems, too?

