Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZHZRSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZHZRSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZHZRSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:18:35 -0400
Received: from outbound-mail-113.bluehost.com ([69.89.24.3]:46888 "HELO
	outbound-mail-113.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751268AbZHZRSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:18:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FCbNSzl3PzC5WjNGzl83OkjcxJHlYOK2BHsnptMcpGG6RbgEFWC5ePymNnr1DyG18sNrQ5kePZTLACg6SpPW/e7sroZMZFCoXAGOXbuwiIcFoa1QetQdXNjA93cMPKYY;
Date: Wed, 26 Aug 2009 10:18:25 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
       Eric Anholt <eric@anholt.net>, mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: Linux 2.6.31-rc7
Message-ID: <20090826101825.455d280e@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.01.0908260943590.3218@localhost.localdomain>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
	<4A941E8B.8080902@plzk.org>
	<alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
	<4A94599F.9020508@plzk.org>
	<alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
	<1251239637.26348.20.camel@gaiman.anholt.net>
	<20090826015127.GA1402@zhen-devel.sh.intel.com>
	<alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>
	<21d7e9970908252047g6db2fb2aj69280efa5eebe681@mail.gmail.com>
	<alpine.LFD.2.01.0908252056170.3218@localhost.localdomain>
	<21d7e9970908252158q30d7e4fay587458b79cd0c36d@mail.gmail.com>
	<alpine.LFD.2.01.0908260943590.3218@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 10:12:14 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> In all three cases the end result is "no EDID", but regardless of
> that, the correct action is basically _never_ to say "ok, I'll just
> assume that the display is on connector XYZ regardless of what the
> state of the graphics chip is".

Yeah, that's normal.  Most builtin panels don't have EDIDs.  Failures
on attached monitors are potentially more serious.

> > so yes I think do better at failing is what is needed, its still
> > failing but its more user friendly fail.
> 
> Yes. If something fails ("oops, I can't seem EDID for any
> connector"), I wish KMS would fail way better than just default to
> some crazy setup. The failure mode should be to at least drive
> whatever the BIOS enabled.

Right, we need to improve our detection heuristics.  We've recently
added some to catch non-existent LVDS displays, but currently don't
have any for VGA.  Using the current configuration as a guide is a
reasonable addition...

-- 
Jesse Barnes, Intel Open Source Technology Center
