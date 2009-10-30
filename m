Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbZJ3ATB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbZJ3ATB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZJ3AS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:18:59 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:38916 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbZJ3AS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qLML2+ZTZHIRBvpdI/cwMQKBgnBpocQPPIJQdE8EL6zzCnsf45MwfSv3JWAorgT/ww
         OieJ1oxP4PhFPK9FlPFBkMk9nMYKxbI48fklaK5y7OD51DTB3af9l9sLrYAQohNdmZMk
         pVru+XLrTPvmnuQxw5GhFGgmAe+hNbObTUs+c=
MIME-Version: 1.0
In-Reply-To: <20091029.031344.102288703.davem@davemloft.net>
References: <4AE64FCC.4030102@gmail.com>
	 <20091029.031344.102288703.davem@davemloft.net>
Date: Thu, 29 Oct 2009 18:19:03 -0600
Message-ID: <51f3faa70910291719kecb5edcp3b8812981b69acb1@mail.gmail.com>
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
From: Robert Hancock <hancockrwd@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 4:13 AM, David Miller <davem@davemloft.net> wrote:
> From: Robert Hancock <hancockrwd@gmail.com>
> Date: Mon, 26 Oct 2009 19:41:32 -0600
>
>> The current Kconfig text for CONFIG_IDE doesn't give a hint to users that this
>> subsystem is currently in maintenance mode and isn't actively developed.
>> Let's correct this by marking it as deprecated, and also get rid of a bunch of
>> unnecessary text that doesn't really have anything to do with what the option is
>> for.
>>
>> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
>
> Applied to ide-next-2.6, thanks.
>
> But honestly, we have to reword or revert this if certain
> things don't happen before the next merge window.
>
> What it comes to is that two things have to happen before
> we can completely shut down IDE and schedule it's removal.

Well, that's why it's a Kconfig patch and not an entry in the feature
removal schedule.. the idea is to tell people that while they can
continue using the code for now, it's not under active development and
will likely someday go away, so migrate if you can. That doesn't imply
that we're close to being able to schedule IDE removal yet.

>
> 1) Add a way for the ATA layer to create compat device
>   nodes so that people can change over to use the ATA
>   layer for their devices without any fstab et al. changes.
>
>   These compat device nodes do not have to be so featureful
>   that they support hdparm or smartd or anything like that,
>   but they need to work well enough to mount filesystems, and
>   mount swap partitions, and interact with device management
>   systems like udev as if they were real IDE devices.

I'm not really sure if this is worthwhile.. is having to update fstab
really so onerous as to be worth the trouble? You'd presumably have to
enable the creation of the compat device nodes somehow (enabling them
by default seems like it would cause a lot of confusion), so it's not
like you wouldn't need any config changes that way, either.

I think people would be better off just updating their fstab and being
done with it.. preferably switching to something like mounting by
label or UUID so that things just work even if the devices get
reordered when they rearrange their cables or add a new controller,
etc. Every Fedora/Red Hat-derived OS has set things up this way by
default for years..

>
> 2) The two or so remaining devices which have IDE support but
>   don't have an ATA layer driver need porting.

Has anyone gone through and made a list of these? pmac seems like the
most obvious one..

>
> I plan to work on #1 if I get the time.  Someone with the requisite
> hardware needs to work on #2, and I'm sure whoever wants to work on
> that will find it easy to get help from some ATA layer experts.
>
