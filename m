Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbYBYWyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbYBYWyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758894AbYBYWyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:54:15 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758527AbYBYWyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:54:14 -0500
Date: Mon, 25 Feb 2008 14:51:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Nix <nix@esperi.org.uk>, Peter Osterlund <petero2@telia.com>,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Jan Kara <jack@ucw.cz>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow:
 ide-cd related? dm-related?
Message-Id: <20080225145156.4184b509.akpm@linux-foundation.org>
In-Reply-To: <20080225224807.GA15700@atrey.karlin.mff.cuni.cz>
References: <87wsovkth5.fsf@hades.wkstn.nix>
	<87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com>
	<87oda6p9st.fsf@hades.wkstn.nix>
	<20080225123041.401da103.akpm@linux-foundation.org>
	<20080225224807.GA15700@atrey.karlin.mff.cuni.cz>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 23:48:07 +0100 Jan Kara <jack@suse.cz> wrote:

> > udf_process_sequence() seems to be another victim of gcc inlining.
>   Hmm, I'll have a look what we can do.

noinline...

> > udf_add_entry() defines a couple of 256-byte local arrays.
>   Yes, exactly two of them. One is  non-trivial to get rid of - it's
> used for encoding of filename before we write it, but one is used during
> scanning of the directory whether the entry doesn't already exists (oh,
> my!) and we can just rip that off..

kmalloc is quite fast ;)
