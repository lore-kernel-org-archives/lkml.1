Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0BCIgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 03:36:42 -0500
Received: from verein.lst.de ([213.95.11.210]:33845 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab0BCIgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 03:36:40 -0500
Date: Wed, 3 Feb 2010 09:36:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Christoph Hellwig <hch@lst.de>, roland@redhat.com, oleg@redhat.com,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 4/14] avr32: use generic ptrace_resume code
Message-ID: <20100203083611.GA29025@lst.de>
References: <20100202185755.GA3630@lst.de> <20100202185857.GD3630@lst.de> <20100203084737.6e01247b@siona>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203084737.6e01247b@siona>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 08:47:37AM +0530, Haavard Skinnemoen wrote:
> Sounds like you found three bugs and fixed two of them. Can you tell me
> more about the last one, i.e. what should be done to disable
> single-stepping?

I don't think the flag clearing on PTRACE_KILL matters as the process
is a zombie and almost gone anyway, it's more an artefact of the
generic implementation that I wanted to mention.

It seems like avr32 implement single stepping by setting the
TIF_SINGLE_STEP and TIF_BREAKPOINT thread flags.  Simply clearing these
flags in user_disable_single_step and calling that function from
ptrace_disable (which currently clears them itself) should take care
of it. 
