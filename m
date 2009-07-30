Return-Path: <linux-kernel-owner+w=401wt.eu-S1751946AbZG3Oen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbZG3Oen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZG3Oen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:34:43 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:57188 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZG3Oem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=q+sBkGP58ZUjooJxrwi9fLhoflzyVWZUlGGMUkfjgWKW9MLEbREoskNKyCryghraAk
         WUgtB90ktTw8B+2GIT+nkq3Ve4C0AsDqfDgV8yprnka0VXMT58VthUPAnf4xkF+ThJns
         brY4GtbD/zyQCD4kDDat24fEAJ/3JXGig+iVA=
MIME-Version: 1.0
In-Reply-To: <4A71AD5E.4080704@uiuc.edu>
References: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu> 
	<4A719A27.8050509@linutronix.de> <ce9ab5790907300639k3173446csbd07198055bfe122@mail.gmail.com> 
	<4A71A483.30507@linutronix.de> <ce9ab5790907300714u5c88f1cdk8c0387de5ba9f413@mail.gmail.com> 
	<4A71AD5E.4080704@uiuc.edu>
From: vimal singh <vimal.newwork@gmail.com>
Date: Thu, 30 Jul 2009 20:04:22 +0530
Message-ID: <ce9ab5790907300734l134c8d4agcf8b22b40129b8d9@mail.gmail.com>
Subject: Re: [PATCH] [mtd] fixed faulty check
To: Stoyan Gaydarov <sgayda2@uiuc.edu>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       linux-kernel@vger.kernel.org, David.Woodhouse@intel.com, sr@denx.de,
       kay.sievers@vrfy.org, gregkh@suse.de, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 7:55 PM, Stoyan Gaydarov<sgayda2@uiuc.edu> wrote:
> vimal singh wrote:
>
> On Thu, Jul 30, 2009 at 7:17 PM, Sebastian Andrzej
> Siewior<bigeasy@linutronix.de> wrote:
>
>
> vimal singh wrote:
>
>
> What if you go to 'err_out' due to some other error?? Do not you need
> to free 'info'?
>
>
> We have to and of_flash_remove() takes care of it.
>
>
>
>
> Does this mean that the original patch is fine or does it still need the
> kfree? From what i understand when going to err_out it will take care of
> info using of_flash_remove() so then it is not needed in the if check.

Yes.
But I think, you should still correct freeing 'mtd_list' in the label,
when you jump there even before memory gets allocated for that.

-vimal

>
> -Stoyan
>
> that's correct...
>
>
>
> The initial patch would be shorter if
>  dev_set_drvdata(&dev->dev, info);
> would be moved prior the kzalloc()
>
> Sebastian
>
>
>
>
>
