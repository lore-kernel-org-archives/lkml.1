Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbYLJVdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbYLJVdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbYLJVdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:33:12 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:53914 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbYLJVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hO8dL3O+4Km0CA/Oj+Pgl2joyUBbOQc7xfXZb+l9bOz8jJQh3JD7mNTmF0HjyAubZs
         /XFjwLkSuFThAIdXOj7IZHVU7aPI8QLhczYiFDOZAt0XhLPyJ04U2spzFjNXa/ba2tdG
         q1p4O2Fh6gCSy75EAyl1RGgAhWd89DNGYq76w=
Date: Thu, 11 Dec 2008 00:26:59 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Vorobiev Dmitri <dmitri.vorobiev@movial.fi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Julia Lawall <julia@diku.dk>,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/28] drivers/base/platform.c: Drop return value from
	platform_driver remove functions
Message-ID: <20081210212659.GA6132@zarina>
Reply-To: cbouatmailru@gmail.com
References: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk> <20081210163819.17cf4628@lxorguk.ukuu.org.uk> <45755.88.114.236.15.1228932236.squirrel@webmail.movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <45755.88.114.236.15.1228932236.squirrel@webmail.movial.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 08:03:56PM +0200, Vorobiev Dmitri wrote:
> > On Wed, 10 Dec 2008 17:26:26 +0100 (CET)
> > Julia Lawall <julia@diku.dk> wrote:
> >
> >> From: Julia Lawall <julia@diku.dk>
> >>
> >> The return value of the remove function of a driver structure, and thus
> >> of
> >> a platform_driver structure, is ultimately ignored
> >
> > Currently
> 
> Are there really any plans about actually using the return value?

It's often used by the drivers, but currently not handled by
the subsystem. For example, _remove() callback might return -EBUSY
or -EAGAIN, which means that whoever called the _remove() should
try later.

For example see drivers/mfd/asic3.c. The driver registers GPIO
chips, on _remove() it *tries* to unregister these chips, but
it could fail (when provided GPIOs are in use by somebody -- it
might be in-kernel users, or sysfs users).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
