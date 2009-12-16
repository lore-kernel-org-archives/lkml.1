Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbZLPRG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbZLPRG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762379AbZLPRGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762296AbZLPRGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:34 -0500
Date: Wed, 16 Dec 2009 12:01:56 -0600
From: David Teigland <teigland@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic allocation
Message-ID: <20091216180155.GA23117@redhat.com>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com> <1257813017-28598-2-git-send-email-cascardo@holoscopio.com> <1257813017-28598-3-git-send-email-cascardo@holoscopio.com> <4AF8B4FF.9050405@zytor.com> <20091111153632.944a255c.akpm@linux-foundation.org> <20091215143446.8b6a7e57.akpm@linux-foundation.org> <20091215233738.26188500@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215233738.26188500@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:37:38PM +0000, Alan Cox wrote:
> > > I merged this patch, but made a note-to-self that there are remaining
> > > open issues..
> > 
> > And nothing else happened.  Can we revisit this please?
> 
> The last I saw was a request for an explanation of the users
> configuration and how he was getting so many misc devices. Its a bug in
> dlm if the dlm is doing that but I didn't see any follow up to the DLM
> folks on the subject from the reporter, so it stays NACKed and conflicts
> with the device registry.

I never saw an indication that the dlm ate up all of someone's misc
devices.  Can we ask the reporter what they were running?

> We need to know from the DLM folks/Thaddeu what is actually going on with
> that system, especially as it seems to be producing multiple
> registrations of the same misc device name which is completely broken and
> should probably be made to error anyway.

I don't believe the dlm will ever register multiple devices with the same
name.

> Whatever is going on this is the wrong "fix". If DLM should only register
> it once (as seems the intent) then DLM needs fixing or the users config
> or both. If it can register many then DLM needs fixing to not eat misc
> devices.

I explained here http://lkml.org/lkml/2009/11/9/379 that the dlm does not
use as many misc devices as has been implied.  It starts with 3, and adds
one for each *userspace* lockspace.  There are very few applications (I
know of 3) that create userspace lockspaces, and they each create about
one each.

That said, I still intend to rework the dlm to use a single device for all
lockspaces.

Dave

