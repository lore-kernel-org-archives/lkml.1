Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbZKDWYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbZKDWYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbZKDWYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:24:42 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53984 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712AbZKDWYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PbVQdDJ3+3lQ7/aCCXveEi2U/9xJuKvBNefFHLHOZXUiT7iv2j9XrFzjPoNtdcKflq
         11GyqhuKEs8Prs+KZ7ERvMT3ihfThgp5+ujUz7W4dD9fbOAcnPEAaLRMJSVUDk+Lh64s
         NK17N7f0XKrxq8Yvpx/IV8n9S0RfrglGoXFPY=
Date: Thu, 5 Nov 2009 01:24:31 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] power: pcf50633: properly reenable charging when
	the supply conditions change
Message-ID: <20091104222431.GB24196@home.pavel.comp>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com> <1257369899-325-2-git-send-email-fercerpav@gmail.com> <1257369899-325-3-git-send-email-fercerpav@gmail.com> <1257369899-325-4-git-send-email-fercerpav@gmail.com> <1257369899-325-5-git-send-email-fercerpav@gmail.com> <20091104214622.GA27325@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104214622.GA27325@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 04, 2009 at 10:46:22PM +0100, Pavel Machek wrote:
> On Thu 2009-11-05 00:24:58, Paul Fertser wrote:
> > If chgmod == BATFULL, setting chgena has no effect. Datasheet says we
> > need to set resume instead but when autoresume is used resume doesn't
> > work. Clear and set chgena instead.
> > 
> > This enables a user to force charging by re-plugging USB even when the
> > charger entered Battery Full mode, might be handy before a long
> > trip.
> 
> And is against manufacturer recommendation and will unneccessary
> shorted life of battery with frequent plugs/unplugs. Is it good idea?

Well, to me it seems that frequent plugs/unplugs is not exactly common
usecase so i consider that to be acceptable.

Especially comparing to millions of laptops and netbooks that always
top their battery while being externally powered and heat it at the
same time, probably the worst conditions lifetime-wise one can
imagine.

> If you want to "top-up" the battery, perhaps that should be on
> explicit request, like something in /sys?

Well, probably but to me it seems like an unnecessary complexity. Also
since Li* batteries are dominating the market nowadays this
functionality would need to be introduced in the power_supply core to
provide userspace with a consistent interface. Anton, can you please
comment on this?

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
