Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbXBEOB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbXBEOB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbXBEOB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:01:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:15608 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbXBEOBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:01:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kjG6QnSMKGwbcxfK2sBBXCTwdDSjiIXZIYrkzzyyYaaVHehSWPgUCy+WusU1Y/7jQfNiBi8wreuHnJSfevEl2en4e7VUXNfwm49h74cXDJ1Do1c6G1/nDcNwl70kSL/whfxtOJ4pXmH7GZexernn6EtrI1+DOX+riGsEvId0Mws=
Message-ID: <84144f020702050601ve2e4746oebd774af9c487b63@mail.gmail.com>
Date: Mon, 5 Feb 2007 16:01:23 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Re: your mail
Cc: logic@thinknet.ro, linux-kernel@vger.kernel.org
In-Reply-To: <20070205123611.GI8804@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1131.86.55.168.2.1170690089.squirrel@mail.thinknet.ro>
	 <20070205123611.GI8804@amd.com>
X-Google-Sender-Auth: 07b8b09f00f18033
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On 2/5/07, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Hmm, this seems to be the same issue as in [1] and [2]. A page that is
> assumed to belong to the slab but is not longer marked as a slab page.
> Could this be a bug in the memory management?

The BUG_ON triggers whenever you feed an invalid pointer to kfree() or
kmem_cache_free() so I am guessing the caller is simply broken. Note
that kernels prior to 2.6.18 would quietly corrupt the slab unless
CONFIG_SLAB_DEBUG was enabled which might explain why this hasn't been
noticed before.

                               Pekka
