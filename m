Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYIOSKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYIOSKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYIOSKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:10:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbYIOSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:10:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=JZekC8gN6LyyxGctt8hOOc20tuaYE6ce3pjRTPW0QerBm2RriDDFF4Ej0q+2asgah
	Z2xijXv3Vue53e5irVl9w==
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080914150923.GB26984@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914150651.GK12522@elte.hu>  <20080914150923.GB26984@elte.hu>
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 15 Sep 2008 11:09:02 -0700
Message-Id: <1221502142.19012.35.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-14 at 17:09 +0200, Ingo Molnar wrote:
> the patch wasnt built on UP i guess - see the fix below.

Yeah, I've been focusing so much on getting the SMP case right that I've
been neglecting UP a bit.

> the wider question is, shouldnt the UP case be just the same as the SMP 
> case? Especially the type assymetry struct thread_group_cputime looks 
> ugly. (and assymetries like that tend to be a constant source of 
> breakage like the one below.)

I'm not overly fond of this one, either; I did it at Roland's suggestion
(it's all _his_ fault, yeah, _that's_ the ticket! :-); his opinion IIRC
was that the UP case will perform better without the extra pointer
dereferences.  I agree that it's a potential source of pain such as the
one you point out.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

