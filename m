Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbXCDXuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbXCDXuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXCDXuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:50:11 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:39109 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbXCDXuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:50:09 -0500
Message-ID: <45EB5B2F.3020505@garzik.org>
Date: Sun, 04 Mar 2007 18:50:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: CK804 SATA Errors (still got them)
References: <200703011339.52895.s0348365@sms.ed.ac.uk> <200703021547.09121.s0348365@sms.ed.ac.uk> <45EB555C.9050606@shaw.ca> <200703042341.38431.s0348365@sms.ed.ac.uk>
In-Reply-To: <200703042341.38431.s0348365@sms.ed.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Sunday 04 March 2007 23:25, Robert Hancock wrote:
>> Alistair John Strachan wrote:
>>>> Can you try reverting commit 721449bf0d51213fe3abf0ac3e3561ef9ea7827a
>>>> (link below) and see what effect that has?
>>>>
>>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
>>>> t;h =721449bf0d51213fe3abf0ac3e3561ef9ea7827a
>>> Obviously, I'll let you know if it happens again, but I've reverted this
>>> commit and transferred 22.5GB over 45 minutes onto a RAID5 with 4 HDs on
>>> an NVIDIA sata controller, and this error hasn't appeared.
>>>
>>> So I'm inclined to (very unscientifically) say that this brings it back
>>> to 2.6.20's level of stability.
>> Interesting. Can you try un-reverting that patch, and applying this one?
> 
> Sorry for the newbie question, but is it adequate to do a:
> 
> 	git reset --hard v2.6.21-rc2
> 
> To ensure a patch is "unreverted" (I reverted it with "git revert"), before 
> applying your patch?
> 
> I've done so now, assuming this _will_ work. The reason I ask is that your 
> diff was offset by 12 lines versus -rc2.

If you committed the revert to the repository, it's probably to blow it 
away and re-clone.  Generally, with git, you want to keep a pristine, 
never-touched-except-for-pulling kernel repository around, and then when 
doing compiles and experiments and such, run

	git-clone --reference my-vanilla-2.6-repo $URL

The --reference argument will ensure that you don't haul around multiple 
copies of the repository objects, with each clone.


Otherwise, if you have committed nothing to the repository, this will 
undo all your not-committed changes:

	git checkout -f

Regards,

	Jeff



