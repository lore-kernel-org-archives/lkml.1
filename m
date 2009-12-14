Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZLNSh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZLNSh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbZLNSh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:37:28 -0500
Received: from outbound-mail-136.bluehost.com ([67.222.39.26]:37958 "HELO
	outbound-mail-136.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750870AbZLNSh1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:37:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pS/ac5+q62pM/2Kf5zBOnRHL62HHt/3aJiP1Udd+f+zjxH2kRCtMoMfEEzQ5ofhRP8s9Ci8OQzo2J8Lwd9jgzYXXPHnQFLAwFd0Wiyb+qNqQ4JeOEpbBRa06/hDP8rgU;
Date: Mon, 14 Dec 2009 10:36:14 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Dave Airlie <airlied@linux.ie>, Jeff Mahoney <jeffm@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fb/intelfb: Do not depend on EMBEDDED
Message-ID: <20091214103614.52ebdafb@jbarnes-piketon>
In-Reply-To: <200912131250.13797.jdelvare@suse.de>
References: <aa541tsbrtanvarunansa3uh.1260654940760@email.android.com>
	<200912131250.13797.jdelvare@suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Dec 2009 12:50:13 +0100
Jean Delvare <jdelvare@suse.de> wrote:
> Le samedi 12 décembre 2009 22:55, Jesse Barnes a écrit :
> > Right, the logic is that the driver really is for embedded (i.e.
> > very special purpose) use.  It should not be selected unless you
> > really know what you're doing or are building a very particular
> > product.   
> 
> The Kconfig help text doesn't say anything about this.
> 
> My understanding is that the intelfb driver was not _designed_ to be
> useful on embedded designs only. It just happens to be incomplete in
> such a way that it works only in a few selected cases, which happen
> to be embedded cases, and it fails in many other cases.
> 
> The proper way to handle this is not to make the driver depend on
> EMBEDDED. The proper way would be to change the intelfb driver so
> that it no longer binds to devices it will not properly support. If
> the driver doesn't support LVDS (whatever it is) then it should
> cleanly fail on systems which have that.

Sorry my last message came across as a bit curt (I was writing on a
phone and didn't want to type anymore :).

Making intelfb not bind to unsupported devices would require a good
chunk of work; it would need to scan available outputs among other
things.

> The reason why I sent a patch in the first place is exactly opposite:
> I want to let distros select this driver. My case is as follows: we
> had a product which included the intelfb driver, which we are in the
> process of upgrading. Now we find that the intelfb driver is gone
> (no longer selectable), which causes a problem as far as the upgrade
> path of our customers is concerned.

Hopefully you can migrate your product to the KMS based fb driver
instead.  It should provide the same functionality but with a better
feature set (e.g. suspend/resume support).

> So the problem I have to solve is: given a customer who was
> successfully using the intelfb driver before, what solutions can we
> offer when said customer upgrades to our new product? My own solution
> was straightforward: keep including the intelfb driver in the new
> product. Thus my patch dropping the dependency on EMBEDDED. If
> another solution exists, please let me know.

Enabling EMBEDDED for your distro would be another option; if you have
a very specific product in mind and want to preserve the same features
and bugs, then that might be the best route in this particular case.

> It would help if the DRM option description was updated. It still
> reads: "Direct Rendering Manager (XFree86 4.1.0 and higher DRI
> support)". If the DRM core is now also providing support for
> framebuffer-like functionality (again, if I understand correctly)
> then the reference to XFree86 should be dropped. The help text
> should also be updated to properly describe all that the DRM core
> offers today.

Yeah, we do need better help text.  People still get confused about
i830 and i810 as well...

-- 
Jesse Barnes, Intel Open Source Technology Center
