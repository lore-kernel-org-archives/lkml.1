Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYGGJ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYGGJ6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 05:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYGGJ6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 05:58:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63685 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYGGJ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mx6q9osxBSkR/jOKbsJUWzHCVPta4XSbNE9x5UoFovu6FkSiTmQLzNjjuqIdrc2Cwu
         kF/5e+iSVPnuMnE05I1o/TqevxMqO7UtMeU3Y4CtkyNCI+PiwpkweehxTVevPROZjRJi
         VM/lHFPq1ysfuDBIcO7bXxeoP8cPZSfUBnMpo=
Date: Mon, 7 Jul 2008 05:57:48 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Timothy Normand Miller <theosib@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: HELP: Getting unexpected fakeraid behavior. Fix?
Message-ID: <20080707095747.GC1631@nineveh.local>
Mail-Followup-To: Timothy Normand Miller <theosib@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org
References: <9871ee5f0807061307ncc55104y477c57be3e91b75f@mail.gmail.com> <20080706131937.13065312@infradead.org> <9871ee5f0807061424o535c6d7eg3071da6e31e0b58e@mail.gmail.com> <9871ee5f0807061822l2871765bhd92aa177c0d5d55b@mail.gmail.com> <9871ee5f0807061826r101a1aboe266a3432af650a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9871ee5f0807061826r101a1aboe266a3432af650a2@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 09:26:35PM -0400, Timothy Normand Miller wrote:
> I was poking around some more, and I found drivers/md/raid1.c.  This
> has sophisticated load balancing for reads.  Why isn't this code being
> used for dm_raid1?  I'm a bit confused as to why this redundant code
> should be there if dmraid and mdraid are functionally the same.

I don't think dmraid and mdraid *are* functionally the same.  dmraid
was written as more or less a compatibilty hack, so people using
fakeRAID with its Windows-only software drivers could still
dual-boot.  That could have changed somewhat while I wasn't looking,
but it doesn't sound like it has changed much.

mdraid is still the only "real" Linux softRAID
implementation... though LVM also does some very RAID-like things.

It would be good if dmraid was better optimized, or more complete --
possibly by reusing some of md -- but no one has done the work.

Anyway, the consensus for a long time seems to be that, unless you
need to dual-boot with a Windows system using fakeRAID drivers, you
should just put the drive controller in AHCI mode and use mdraid.

--
Joseph Fannin
jfannin@gmail.com

