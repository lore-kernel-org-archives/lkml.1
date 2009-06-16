Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZFPAkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZFPAkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 20:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZFPAkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 20:40:12 -0400
Received: from kroah.org ([198.145.64.141]:53851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZFPAkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 20:40:11 -0400
Date: Mon, 15 Jun 2009 17:35:57 -0700
From: Greg KH <greg@kroah.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 21/22] HWPOISON: send uevent to report memory corruption
Message-ID: <20090616003557.GA22690@kroah.com>
References: <20090615024520.786814520@intel.com> <20090615031255.278184860@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615031255.278184860@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:45:41AM +0800, Wu Fengguang wrote:
> +static void hwpoison_release(struct kobject *kobj)
> +{
> +}
> +
> +static struct kobj_type hwpoison_ktype = {
> +	.release = hwpoison_release,
> +};

{sigh}

Why did you include an empty release function?  Was it because the
kernel complained when you had no release function?  So, why would you
think that the acceptable solution to that warning would be an empty
release function instead?

Hint, this is totally wrong, provide a release function that ACTUALLY
DOES SOMETHING!!!  Read the kobject documentation for details as to what
you need to do here.

ugh, I'm so tired of repeating this year after year after year, I feel
like a broken record...

This is broken, please fix it.

greg k-h
