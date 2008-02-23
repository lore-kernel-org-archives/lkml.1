Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbYBWOy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbYBWOy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYBWOyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:54:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:12197 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYBWOyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GReaJDUilmwLHkVLsZtbb/pCDX5nQFQDMEUd6YztTC3G9aYIZ9qIQ5GGku5+IrNyyDd/8X97X7j6CVttx0U2zsLBoc/xnMySs9M4SxxvgiEZDwAJqUcue3eZPPgi1iXpTUgwnG7IJlKjvnfuKnspiB/zncepL4NPzdx7deEXPOY=
Message-ID: <84144f020802230654y3913447bh39390fdd78a96cf3@mail.gmail.com>
Date: Sat, 23 Feb 2008 16:54:49 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Cc: "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
In-Reply-To: <20080223001130.d8922136.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <20080223001130.d8922136.akpm@linux-foundation.org>
X-Google-Sender-Auth: 32ab8ec13a4cf0f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 10:11 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  Seems a poor idea to me.  Sure, oprofile is "hard to set up", but not if
>  your distributor already did it for you.
>
>  Sidebar: the code uses the utterly crappy register_timer_hook() which
>
>  a) is woefully misnamed and
>
>  b) is racy and
>
>  c) will disrupt oprofile if it is being used.  And vice versa.

I wonder if sysprof should hook to the same interrupt as oprofile then?

On Sat, Feb 23, 2008 at 10:11 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  This code adds a new kernel->userspace interface which is not even
>  documented in code comments.  It appears to use a pollable debugfs file in
>  /proc somewhere, carrying an unspecified payload.

[snip]

>  This reads a single item even if there were 100 queued, which is quite
>  inefficient.
>
>  We already have infrastructure for bulk kernel->user transfer in
>  kernel/relay.c?

Agreed. This seems like a perfect fit with relayfs.
