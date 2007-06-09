Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbXFITxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbXFITxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbXFITxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:53:42 -0400
Received: from 1wt.eu ([62.212.114.60]:2936 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbXFITxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:53:41 -0400
Date: Sat, 9 Jun 2007 21:53:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: Christian Kujau <christian@g-house.de>
Cc: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove bashisms from scripts/extract-ikconfig
Message-ID: <20070609195333.GR943@1wt.eu>
References: <alpine.DEB.0.99.0706092117580.8312@foobar-g4> <2F6FAF9E-8997-4FC1-8310-4A7D17C659E4@ac.upc.edu> <alpine.DEB.0.99.0706092132200.8312@foobar-g4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706092132200.8312@foobar-g4>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 09:34:36PM +0200, Christian Kujau wrote:
> On Sat, 9 Jun 2007, Julio M. Merino Vidal wrote:
> >Wouldn't this be better expressed as:
> >
> >  start=$(($start + 8))
> >  size=$(($end - $start))
> >
> >to avoid invoking a subshell?
> 
> This is certainly possible for lots for scripts, but was not the "scope" 
> of this patch. ` is not bash-specific and does not break anything.

That's wrong. It will now require "expr" to be present and working on
the machine, eventhough it's certainly needed for other parts of the
kernel. Also, the remaining function will be considerably slower than
what it initially was. If it's called very frequently, it can be a
problem.

I agree with Julio that if you want to fix the code for its bashism,
you should not change its behaviour and stay as much as possible close
to what it initially did.

Also, beware that the "typeset file=y" did another thing : declare "file"
as local to the function. With your change, any global variable called
"file" will have its content wiped after a call to this function. You
should ensure that it is not used anywhere else, or better, change its
name for something less common than "file".

Regards,
Willy

