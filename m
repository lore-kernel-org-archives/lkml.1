Return-Path: <linux-kernel-owner+w=401wt.eu-S933867AbXHHNqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbXHHNqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbXHHNqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:46:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:61582 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXHHNql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BBY6dkJIaVZgHgi9AWTcU5k8SDl/kbNu9AJJovF05iVZNfhEcD5qFFDLdb5IQeZH7BJmp0J9dLFayMfswISAso1SZXeyVLG5qSAenoUG9NcojAxcwkDPwM03SaEsN3dkYY1IBgbLYvggz75eUB0wGdn45wd+HvVTu8drByn+TlY=
Message-ID: <3ae72650708080646k4279e48boc3a77d6454c8d72d@mail.gmail.com>
Date: Wed, 8 Aug 2007 15:46:40 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: Error message from device_rename in drivers/base/core.c
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <46B9B5C6.2070100@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B943D3.9020207@lwfinger.net>
	 <20070807.213724.27783161.davem@davemloft.net>
	 <20070808113359.71e77f49@gondolin.boeblingen.de.ibm.com>
	 <46B9B5C6.2070100@lwfinger.net>
X-Google-Sender-Auth: 41bc31d879353017
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> Cornelia Huck wrote:
> > On Tue, 07 Aug 2007 21:37:24 -0700 (PDT),
> > David Miller <davem@davemloft.net> wrote:
> >
> >> I think this check belongs in udev not in the kernel.  Thankfully
> >> this message at least tells us it is happening, please don't
> >> remove it.
> >
> > Hm, device_rename() could alternatively just return success if
> > dev->bus_id and new_name are the same.
>
> That is what my proposed patch did. One could argue that the test should come before the failure,
> not after, but the effect is the same.
>
> >> I'm pretty sure it's UDEV doing this, and it should not try to rename
> >> a netdevice to what it already is named.
> >
> > But it shouldn't cause an error either :)
>
> I agree with you, but you and David can fight it out. While finding out where to ask/complain about
> udev, I had a private communication with GregKH. He thinks that a patch to fix this has already been
> pushed through Linus. As Linville's wireless-dev tree is a little behind, I'm waiting to see if it
> gets fixed here by 2.6.23-rc3. If not, I'll talk to the udev/hotplug folks.

Hmm, I can not immediately see how udev could request the renaming to
the same name:

  /* look if we want to change the name of the netif */
  if (strcmp(udev->name, udev->dev->kernel) != 0) {
    ...
    retval = rename_netif(udev);
    ...
  }

What udev version is it and which distro and version?

Kay
