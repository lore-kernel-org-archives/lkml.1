Return-Path: <linux-kernel-owner+w=401wt.eu-S934968AbYBTQci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968AbYBTQci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764838AbYBTQOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:14:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbYBTQOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:14:08 -0500
Date: Wed, 20 Feb 2008 08:11:37 -0800
From: Greg KH <greg@kroah.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, olof@lixom.net, sam@ravnborg.com
Subject: Re: [PATCH] Add PCI_DEVICE_TABLE macro
Message-ID: <20080220161137.GB2658@kroah.com>
References: <1203250205-5103-1-git-send-email-jonas@southpole.se> <1203250404.24325.1.camel@satguru> <20080218044834.GB14184@kroah.com> <47B93512.6000107@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B93512.6000107@southpole.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 08:34:42AM +0100, Jonas Bonn wrote:
>> And again, what does this buy us?
>
> Clarity and simplicity, I hope... there are a bunch of definitions 
> scattered about the kernel that omit the __devinitdata modifier despite the 
> documentation stating that it should always be there.  The definition 
> really should have been const, which wasn't possible before but has become 
> so with the addition of the __devinitconst attribute.
>
> Furthermore, there are definitions that use "const" and __devinitdata, 
> which is explicitly wrong but the compiler doesn't catch section mismatches 
> if there's only one such one case in the module (which is often the case).
>
> Adding the __devinitconst modifier where there was nothing before buys us 
> memory.  Adding the const modifier gives the compiler a chance to do its 
> thing.  Changing __devinitdata to __devinitconst where it was wrong 
> actually fixes some compiler errors in older (mid-release) kernels that 
> were patched over by "removing" the section attribute altogether (which 
> wastes memory).
>
> Adding the macro (Olof's idea, not mine) makes it pretty difficult to get 
> this definition wrong... I'll do the rest of the cleanup, but I need to 
> know whether it's better to use a macro like this, or to open code the 
> definitions.  I prefer the macro approach...
>
> Hope this makes some sense...

Ok, yes it does, thanks for the explaination.

Please, can you add this very good text to the changelog entry for the
addition of the macro, and to the documentation somewhere?  I'd be glad
to take the patch if that was done.

thanks,

greg k-h
