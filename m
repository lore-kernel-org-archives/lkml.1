Return-Path: <linux-kernel-owner+w=401wt.eu-S932784AbXIGO6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbXIGO6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbXIGO6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:58:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:40514 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbXIGO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iTTU88jfBXk3gA7/6zt6lg6NGD5IKhgIhh1+nw4+EWpzWOICgxdJouqRqvpyeGFCPNslF96ZtketsVxisFH+TiEWEgrOlvsFozET0B31GahhfK7IKu0BLsUKTdVvoAFl0mvhVjI8QNzoDu6hZFKCH0r6l+rwD+jyL3mO9peJaFM=
Message-ID: <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
Date: Fri, 7 Sep 2007 10:58:31 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: Platform device id
Cc: "Greg KH" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>
In-Reply-To: <20070907153559.17faf9d1@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070907153559.17faf9d1@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 9/7/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Greg, all,
>
> While platform_device.id is a u32, platform_device_add() handles "-1" as
> a special id value. This has potential for confusion and bugs. One such
> bug was reported to me by David Brownell:
>
> http://lists.lm-sensors.org/pipermail/i2c/2007-September/001787.html
>
> And since then I've found two other drivers  affected (uartlite and
> i2c-pxa).
>
> Could we at least make platform_device.id an int so as to clear up the
> confusion? I doubt that the id will ever be a large number anyway.
>
> To go one step further, I am questioning the real value of this naming
> exception for these "unique" platform devices. On top of the bugs I
> mentioned above, it has potential for compatibility breakage: adding a
> second device of the same type will rename the first one from "foo" to
> "foo.0". It also requires specific checks in many individual platform
> drivers. All this, as I understand it, for a purely aesthetic reason. I
> don't think this is worth it. Would there be any objection to simply
> getting rid of this exception and having all platform devices named
> "foo.%d"?
>

If a device has a <name>.<instance> scheme this implies possibility of
having several instances of said device in a box. There are a few of
platform devices that can only have one instance - for example i8042
keyboard controller (the -1 special handling came from me because
i80420 name was very confusing - there wasn't a dot separator in the
name back then). Drivers that allow multiple devices should not
attempt to use -1 for the very first instance - this should eliminate
potential for error and special handling that you are talking about.

-- 
Dmitry
