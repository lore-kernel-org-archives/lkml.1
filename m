Return-Path: <linux-kernel-owner+w=401wt.eu-S1751453AbXAaSnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbXAaSnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXAaSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:43:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:8884 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXAaSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:43:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=cylQxx1YPXjETdl+GIZee7u5KrOuZRLJXcwuG3PpKQRNhjsw4jfyu9YVCvApH2LJjNXxeiN59vJY5dnWuKtEiV7XTDLRIxr4ZRAWGPaji454wJccCMOeQ99ZB7mzoC3PpUdroq1a1WEUkbLPCvVcVoMx8I3SzsCVibOEEJGTtkY=
Date: Wed, 31 Jan 2007 21:42:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: remove_proc_entry and read_proc
Message-ID: <20070131184251.GA5544@martell.zuzino.mipt.ru>
References: <200701311154.35929.duncan.sands@math.u-psud.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701311154.35929.duncan.sands@math.u-psud.fr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 11:54:35AM +0100, Duncan Sands wrote:
> Can read_proc still be executing when remove_proc_entry returns?
>
> In my driver [*] I allocate some data and create a proc entry using
> create_proc_entry.  My read method reads from my allocated data.  When
> shutting down, I call remove_proc_entry and immediately free the data.
> If some call to read_proc is still executing at this point then it will
> be accessing freed memory.  Can this happen?  I've been rummaging around
> in fs/proc to see what prevents it, but didn't find anything yet.

This should be fixed by the following patch (in -mm currently):
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/fix-rmmod-read-write-races-in-proc-entries.patch

Tell me if you're unsure it will.

