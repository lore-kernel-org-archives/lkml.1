Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYJCATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYJCATS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 20:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYJCATI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 20:19:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:26036 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbYJCATH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 20:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iT8yXYhbTdFXRVazUxIq+xrLePD6WXNRLq33yv9I939je1mMPgrALk1+DPN1B+ara8
         /wsgGWenYLfk5JwXfOcgUUxxCDILVwI6J2HF1Dc07eo4+jRVGgi1+hnrg7fkkF6tnZvL
         jjo3v5EdqwK1EUXDKGy1zqOVMkwo34fRRWoe0=
Message-ID: <4807377b0810021719m164e734cndaddb7006508cabc@mail.gmail.com>
Date: Thu, 2 Oct 2008 17:19:06 -0700
From: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] e1000e: prevent concurrent access to NVRAM
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Olaf Kirch" <okir@suse.de>,
       "Jiri Kosina" <jkosina@suse.cz>,
       "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-netdev@vger.kernel.org,
       kkeil@suse.de, agospoda@redhat.com, arjan@linux.intel.com,
       david.graham@intel.com, bruce.w.allan@intel.com, john.ronciak@intel.com,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.10.0810030041060.5549@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
	 <20080930031952.22950.45228.stgit@jbrandeb-bw.jf.intel.com>
	 <Pine.LNX.4.64.0810021624380.1887@twin.jikos.cz>
	 <200810021703.43770.okir@suse.de>
	 <alpine.LFD.1.10.0810030041060.5549@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 4:42 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> The confirmed bugs where the nvram acquire code was called
> concurrently are still in your tree and the prevention patch along
> with the resulting bugfixes are stuck in some obscure intel QA
> process.
>
> Please apply at least the bug prevention patch below.

This is the same patch I posted 7 minutes ago, except that this patch
without the e1000e changes applied before it will cause all sorts of
WARN's to be printed during normal operation.  If at all possible I
think they should stay together as a group to prevent un-necessary
noise in the logs.
