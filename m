Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZHaW0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZHaW0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 18:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZHaW0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 18:26:42 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:44686 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZHaW0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 18:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=JNIxXdTCcZHlBALMlufqUF71xOnLz1ydNEQnhjXcBbwyiYU7JDT5AFpZGDvBIv82FH
         QD7Hff9IcHRvZAZr+7yHn9btKGe6QTqxyhdkSIMZt2nz5fDJyv5rnUtlJySvxAqsUtjN
         0P/g/JnGRRszaFZ4ODalL34aZwVNvnqjaJ7TM=
MIME-Version: 1.0
In-Reply-To: <20090831180746.GA32110@piper.oerlikon.madduck.net>
References: <4A947682.2010204@redhat.com> <4A967175.5070700@redhat.com>
	 <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>
	 <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu>
	 <20090830075135.GA1874@ucw.cz> <20090830152023.GB23828@mit.edu>
	 <4807377b0908311049id9a2167r937bc8447c2b3546@mail.gmail.com>
	 <20090831180746.GA32110@piper.oerlikon.madduck.net>
Date: Mon, 31 Aug 2009 15:26:42 -0700
Message-ID: <4807377b0908311526r3b42f581j27b9c26166b7ac96@mail.gmail.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3: 
	document conditions when reliable operation is possible)
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
       NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 11:07 AM, martin f krafft<madduck@debian.org> wrote:
> also sprach Jesse Brandeburg <jesse.brandeburg@gmail.com> [2009.08.31.1949 +0200]:
>> In the case of a degraded array, could the kernel be more
>> proactive (or maybe even mdadm) and have the filesystem remount
>> itself withOUT journalling enabled?  This seems on the surface to
>> be possible, but I don't know the internal particulars that might
>> prevent/allow it.
>
> Why would I want to disable the filesystem journal in that case?

I misspoke w.r.t journalling, the idea I was trying to get across was
to remount with -o sync while running on a degraded array, but given
some of the other comments in this thread I'm not even sure that would
help.  the idea was to make writes as safe as possible (at the cost of
speed) when running on a degraded array, and to have the transition be
as hands-free as possible, just have the kernel (or mdadm) by default
remount.
