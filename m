Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbXEIPBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbXEIPBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXEIPBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:01:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:47722 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbXEIPBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=I9gKQ2SDUMG9bdmaXeiceAd+KssReFPxg4B/011RozaVYUMiDOnxnLkcngXQLI6fbuLTic3QXk1stcYseVnDg4TpES1IRv/DCMp0ulvI+1o8ttoOmQveOyldt/GK5gIpI7IQ+8e6O1d13I514k1HMRpDaP/NFIEA6AknSjY29p0=
Message-ID: <4641E245.7040603@gmail.com>
Date: Wed, 09 May 2007 17:01:25 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chris Rankin <rankincj@yahoo.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x	(kernel
 bug 8198)
References: <602729.80444.qm@web52910.mail.re2.yahoo.com> <4641CD01.6010309@gmail.com> <20070509145747.GA27259@kroah.com>
In-Reply-To: <20070509145747.GA27259@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, May 09, 2007 at 03:30:41PM +0200, Tejun Heo wrote:
>> Chris Rankin wrote:
>>> --- Tejun Heo <htejun@gmail.com> wrote:
>>>> So, we can fix the problem Chris is seeing by breaking module unload (by
>>>> allowing it to unload too early).  It doesn't sound too hot but module
>>>> unloading race is much less likely than sysfs node deletion/open race.
>>> Yikes! Just temporary breakage, I hope :-)!! The only modules I unload on a regular basis these
>>> days are things like "microcode", which the init scripts take care of as part of the boot-up
>>> process.
>> Okay, here's a half-assed fix.  With this patch applied, if you try to
>> unload a module while you're opening it's dev attribute, kernel will
>> oops later when the file is accessed or closed later but it should fix
>> the bug winecfg triggers.  I really dunno how to fix this the right way
>> in the stable kernel.  Better ideas?  Anyone?
> 
> This looks like the correct fix, the only reason I made this dynamic was
> to properly set up the module owner.  And now that you have removed that
> link in your sysfs rework, it can go and become static again.
> 
> Oh, and this isn't a "device node", it's just a text file that contains
> the major:minor number for a device node to be created from.
> 
> So, care to fix up the class code too and send a patch with a
> signed-off-by:?

I think the proper fix for -stable is to free the structure in
device_release().  I asked Chris to test it.  After he confirms, I'll
send a proper patch with S-O-B.

For -mm, yeap, we can simply make the whole thing static.  I'll send
patch for that soon.

Thanks.

-- 
tejun
