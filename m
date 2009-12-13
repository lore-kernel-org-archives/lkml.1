Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZLMLuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZLMLuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZLMLuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:50:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57594 "HELO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752683AbZLMLuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:50:08 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH] fb/intelfb: Do not depend on EMBEDDED
Date: Sun, 13 Dec 2009 12:50:13 +0100
User-Agent: KMail/1.9.1
Cc: Jeff Mahoney <jeffm@suse.de>, linux-kernel@vger.kernel.org
References: <aa541tsbrtanvarunansa3uh.1260654940760@email.android.com>
In-Reply-To: <aa541tsbrtanvarunansa3uh.1260654940760@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912131250.13797.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave, Jesse,

Dave Airlie <airlied@linux.ie> wrote:
>> I am worried that the intelfb driver depends on EMBEDDED. I consider
>> this an abuse of the EMBEDDED configuration option, which as I
>> understand it was originally meant to expose fine-tuning options,
>> rather than to arbitrarily disable drivers when not selected.
>
>Since we merged a kms driver for Intel hw that supports all intel chipsets
>and more importantly all the outputs on Intel chipsets, intelfb should
>be considered legacy at the least and broken on > 50% of intel hw.

Are you suggesting that the "kms driver" is a drop-in replacement for
intelfb? More specifically, can I use that "kms driver" to get a
high-resolution console?

>We left it in in that most ppl who wanted it were using it in embedded 
>configs, whereas for most users it just doesn't work, like I don't think
>it supports LVDS which means loading it on a laptop will trash it.

The intelfb driver is marked EXPERIMENTAL, so it is already expected to not
work perfectly in all cases.

Le samedi 12 décembre 2009 22:55, Jesse Barnes a écrit :
> Right, the logic is that the driver really is for embedded (i.e. very
> special purpose) use.  It should not be selected unless you really
> know what you're doing or are building a very particular product.   

The Kconfig help text doesn't say anything about this.

My understanding is that the intelfb driver was not _designed_ to be
useful on embedded designs only. It just happens to be incomplete in
such a way that it works only in a few selected cases, which happen
to be embedded cases, and it fails in many other cases.

The proper way to handle this is not to make the driver depend on
EMBEDDED. The proper way would be to change the intelfb driver so
that it no longer binds to devices it will not properly support. If
the driver doesn't support LVDS (whatever it is) then it should
cleanly fail on systems which have that.

> If you can think of a better way of preventing users and distros
> from accidentally selecting this,

The reason why I sent a patch in the first place is exactly opposite:
I want to let distros select this driver. My case is as follows: we
had a product which included the intelfb driver, which we are in the
process of upgrading. Now we find that the intelfb driver is gone
(no longer selectable), which causes a problem as far as the upgrade
path of our customers is concerned.

So the problem I have to solve is: given a customer who was
successfully using the intelfb driver before, what solutions can we
offer when said customer upgrades to our new product? My own solution
was straightforward: keep including the intelfb driver in the new
product. Thus my patch dropping the dependency on EMBEDDED. If
another solution exists, please let me know.

> then please send a patch. 

First of all, I'd need to better understand how the various drivers
relate to each other, and what functionality they provide. In my
little outdated mind, framebuffer is for high-resolution console
without X, while drm is for accelerated X. Apparently this changed
more or less recently, but the documentation wasn't updated.

It would help if the DRM option description was updated. It still
reads: "Direct Rendering Manager (XFree86 4.1.0 and higher DRI
support)". If the DRM core is now also providing support for
framebuffer-like functionality (again, if I understand correctly)
then the reference to XFree86 should be dropped. The help text
should also be updated to properly describe all that the DRM core
offers today.

Honestly, I'm probably not the best person to write this text, as I
don't know much about the current state of this graphics stuff.

Thanks,
-- 
Jean Delvare
Suse L3
