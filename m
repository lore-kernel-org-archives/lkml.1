Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYHROnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYHROnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYHROm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:42:58 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:48572 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbYHROm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:42:56 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH REVIEW] udf: Fix lock inversion between iprune_mutex and alloc_mutex (v2)
Date: Mon, 18 Aug 2008 16:34:29 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <12190639982548-git-send-email-jack@suse.cz>
In-Reply-To: <12190639982548-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181634.29724.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Monday 18 August 2008, Jan Kara wrote:
> A memory allocation inside alloc_mutex must not recurse back into the
> filesystem itself because that leads to lock inversion between iprune_mutex and
> alloc_mutex (and thus to deadlocks - see traces below). alloc_mutex is actually
> needed only to update allocation statistics in the superblock so we can drop it
> before we start allocating memory for the inode.

On a quick review, this is correct.


Best Regards

Ingo Oeser
