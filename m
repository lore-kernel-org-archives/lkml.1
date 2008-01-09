Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYAIAp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYAIAp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYAIApV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:45:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51775 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYAIApU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:45:20 -0500
Date: Wed, 9 Jan 2008 01:47:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109004748.GI2117@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <20080108185255.GA4627@martell.zuzino.mipt.ru> <20080108191843.GA1004@one.firstfloor.org> <200801090140.58864.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801090140.58864.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 01:40:58AM +0100, Arnd Bergmann wrote:
> On Tuesday 08 January 2008, Andi Kleen wrote:
> > > Thanks, Andi! I think it'd very useful change.
> > 
> > Reminds me this is something that should be actually flagged
> > in checkpatch.pl too
> > 
> > Andy, it would be good if checkpatch.pl complained about .ioctl = 
> > as opposed to .unlocked_ioctl = ...
> 
> This is rather hard, as there are different data structures that
> all contain ->ioctl and/or ->unlocked_ioctl function pointers.
> Some of them already use ->ioctl in an unlocked fashion only,
> so blindly warning about this would give lots of false positives.

I imagined it would check for 

+struct file_operations ... = { 
+      ...
+	.ioctl = ...

That wouldn't catch the case of someone adding only .ioctl to an 
already existing file_operations which is not visible in the patch context, 
but that should be hopefully rare. The more common case is adding
completely new operations

>  
> > Also perhaps if a whole new file_operations with a ioctl is added
> > complain about missing compat_ioctl as a low prioritity warning?
> > (might be ok if it's architecture specific on architectures without
> > compat layer)
> 
> Also, not every data structure that provides a ->ioctl callback
> also has a ->compat_ioctl, although there should be fewer exceptions

That's probably a bug in general. e.g. those likely won't work 
at all on the "compat by default" architectures like sparc or ppc64.

-Andi

