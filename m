Return-Path: <linux-kernel-owner+w=401wt.eu-S1030443AbXAYRDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030443AbXAYRDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030363AbXAYRDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:03:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:63561 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030443AbXAYRDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=biuh77ZAQTXDwnLjPSJi2z0PK6oe0sQOemFbGU05apoDjVtzlEJr79xjJrZyZSdWrd661FxFK40celQQLgHMXwJfqEqFhjmeGsdNRXWLyYMjwTEe7AND4AdwKgoKpWKJUlnyl4QpNoedyIdeFKhoIpMTjgV7dXJbt1fhVJMkBcE=
Message-ID: <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
Date: Thu, 25 Jan 2007 12:03:12 -0500
From: "Christopher \"Monty\" Montgomery" <xiphmont@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Pierre Ossman" <drzeus@drzeus.cx>, fedora-desktop-list@redhat.com,
       alsa-devel@alsa-project.org, jrb@redhat.com, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <s5hfy9zujvr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
	 <20070125042616.GA21813@kroah.com>
	 <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>
	 <45B8C9A3.6060107@drzeus.cx>
	 <806dafc20701250736yc5c3048u14ec98e9b6b92574@mail.gmail.com>
	 <45B8CF7E.2040908@drzeus.cx>
	 <806dafc20701250757n3dcb38b7ma5f8423ab3de9850@mail.gmail.com>
	 <s5hfy9zujvr.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > What was there (plugging the old 'dev' arg into the new call's
> > 'parent' makes no sense) is clearly wrong.
>
> It makes sense because the meaning of card->dev was changed, too.
> Now it points the "card*" object that is the root of all belonging
> devices.  The former card->dev is stored in card->parent.

Unfortunately card->parent does not work... but card->dev->parent does...

> > And it's clear my pacth is incomplete, as it doesn't correct the
> > device entries for the other entries.
>
> Well, for older systems, we shouldn't have also "card*" objects, too.

True enough.

> An untested patch below...

This patch does not correct the problem, unfortunately.  I had
originally tried something similar, but card->parent still results in
the device symlink pointing to ../../../class/cardN.

I'm working on this now and will doublecheck just in case my test was
flawed first time.

Monty
