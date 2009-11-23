Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZKWRh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZKWRh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZKWRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:37:28 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:64377 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZKWRh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:37:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TNPH+d/N9aPAQabUbPhKazlH1KGJvOdGcNIRZfLFB8apYNJdFlemunBaZXjHpmC4Az
         roFgaE5KoEZQ+1//s5J9i5kuhvMsHhh8ru3TTZzPOgwxKt1zy9nIS8n+ddfyUhemNs/F
         PkkRCGsRxa5IkBsffKIgc7TYgLOIyw5NwFhgQ=
Date: Mon, 23 Nov 2009 09:37:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
       Mario Limonciello <superm1@ubuntu.com>, linux-input@vger.kernel.org,
       linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091123173726.GE17813@core.coreip.homeip.net>
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m36391tjj3.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 03:14:56PM +0100, Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> > Event input has the advantage that the keystrokes will provide an unique
> > representation that is independent of the device.
> 
> This can hardly work as the only means, the remotes have different keys,
> the user almost always has to provide customized key<>function mapping.
> 

Is it true? I would expect the remotes to have most of the keys to have
well-defined meanings (unless it is one of the programmable remotes)...

> 
> Perhaps the raw RCx data could be sent over the input layer as well?
> Something like the raw keyboard codes maybe?
>

Curreently the "scan" codes in the input layer serve just to help users
to map whatever the device emits into a proper input event code so that
the rest of userspace would not have to care and would work with all
types of devices (USB, PS/2, etc).

I would not want to get to the point where the raw codes are used as a
primary data source.

> We need to handle more than one RC at a time, of course.
> 
> > So, the basic question that should be decided is: should we create a new
> > userspace API for raw IR pulse/space
> 
> I think so, doing the RCx proto handling in the kernel (but without
> RCx raw code <> key mapping in this case due to multiple controllers
> etc.). Though it could probably use the input layer as well(?).
> 

I think if the data is used to do the primary protocol decoding then it
should be a separate interface that is processed by someone and then fed
into input subsystem (either in-kernel or through uinput).

Again, I would prefer to keep EV_KEY/KEY_* as the primary event type for
keys and buttons on all devices.

-- 
Dmitry
