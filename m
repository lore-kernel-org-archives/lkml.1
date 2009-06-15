Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbZFOCsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbZFOCsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZFOCsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:48:38 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:59590 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZFOCsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JFPxlDvJEKReTMeW0RLNlsDrqR8KrnQR+A8eHHXfCYA7UNhUFGFg238eLlR0o+Y55l
         FVCBm/jJQ9O4dd5SMX5Qa9ExIUWBiL1EAZ8lvdJhX3Hx4ggUUu9LHCL3stIKbh9a7N2I
         hM8OVn79luGxzxHn83yk4bS8sTQ8n8OxPqurU=
MIME-Version: 1.0
In-Reply-To: <20090615022235.GA12905@kroah.com>
References: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie>
	 <20090615022235.GA12905@kroah.com>
Date: Mon, 15 Jun 2009 12:43:38 +1000
Message-ID: <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com>
Subject: Re: [git pull] drm - fixes + radeon KMS (part 2)
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 12:22 PM, Greg KH<greg@kroah.com> wrote:
> On Mon, Jun 15, 2009 at 03:08:56AM +0100, Dave Airlie wrote:
>>
>> Hi Linus,
>>
>> Please pull the 'drm-linus' branch from
>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>>
>> This is big. It contains the initial TTM memory manager + ATI radeon KMS
>> support. Currently the KMS code is part of the DRM radeon driver however
>> it is very clearly separated internally from the old codepaths. We've
>> elected to keep the radeon KMS Kconfig build/enable under staging for now
>> since we may have some ABI tweaks to sort out in this release cycle,
>> however the code is all in the drm. I don't think this enables crap
>> tainting, but at least no-one will find kms by accident.
>
> No, the module loader looks for stuff in drivers/staging/ to cause a
> "taint".
>
> But why not just keep the Kconfig stuff in your own directory, and
> depend on CONFIG_STAGING if you want to not have it show up for "normal"
> users?  It seems odd to put anything in drivers/staging/Kconfig for
> something that is not in drivers/staging.
>
> I'm guessing this Kconfig change was not in linux-next?  Or had it been
> there and I just missed it somehow?
>

No since I was on holidays until the just before the merge window
opened, the patches
did get posted to lkml but missed your cc.

Well we'd like to make sure people go via the staging menus to get at
the kconfig option
for now, granted it probably doesn't matter whether it goes in staging
menus or in drm depends
on CONFIG_STAGING. Up to you I can post a patch after this merge to
move it to drm.

Since its only temporary I'm not hugely pushed about taint.

Dave.
