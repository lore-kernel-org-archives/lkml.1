Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbXJ2Gao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbXJ2Gao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXJ2Gah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:30:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:24983 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbXJ2Gag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BaHOTxfDu9UFzf/PZGebfDE1RMxvIk6V462lxIVLsDf1xP9I+Dxptw3/KuubhI2HpgFFD67/V5vKSNopd4uQRhCsalaaa7Tba/uCZX3B7kNoJIUOTyj5phwyeXZcenUF5pFjERph8/4nfb+nkx8FCMeZv7NtEEss48dp9/AAX1g=
Message-ID: <84144f020710282330v5df5df32v1a766e653081a751@mail.gmail.com>
Date: Mon, 29 Oct 2007 08:30:35 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 09/10] SLUB: Do our own locking via slab_lock and slab_unlock.
Cc: "Matthew Wilcox" <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0710282001000.28636@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071028033156.022983073@sgi.com>
	 <20071028033300.479692380@sgi.com>
	 <Pine.LNX.4.64.0710281702140.6766@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0710282001000.28636@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: d7b9779fbe510cde
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/29/07, Christoph Lameter <clameter@sgi.com> wrote:
> > We don't need preempt_enable for CONFIG_SMP, right?
>
> preempt_enable is needed if preemption is enabled.

Disabled? But yeah, I see that slab_trylock() can leave preemption
disabled if cmpxchg fails. Was confused by the #ifdefs... :-)
