Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbYCOUkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbYCOUkd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 16:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYCOUkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 16:40:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:36957 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYCOUkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 16:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u/S4nk/dKq+IunByQQoMbF8QaPv/0PwF4qqFJjGuWG0LkPKrD6HQ23MX+sjYgLyJmKfyStMDPnnMoEFLqekLzDZobVZnLm8zLZkG6OMcqBnqPVpX/ESz41kFIeZWn/TcUpokTjMT8LxsxX12Q5KPg2dbH7DQxBhMWTl6HpepWCs=
Message-ID: <170fa0d20803151340h78a4f01ey843b0ce4a0e11e2a@mail.gmail.com>
Date: Sat, 15 Mar 2008 16:40:22 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Cc: "Daniel Phillips" <phillips@phunq.net>,
       "David Newall" <davidn@davidnewall.com>, david@lang.hm,
       "Chris Friesen" <cfriesen@nortel.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20080315202625.GC4193@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803092346.17556.phillips@phunq.net>
	 <200803131232.07879.phillips@phunq.net>
	 <47D9856E.9010304@davidnewall.com>
	 <200803131303.04118.phillips@phunq.net> <20080315202625.GC4193@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 4:26 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2008-03-13 12:03:03, Daniel Phillips wrote:
>  > On Thursday 13 March 2008 12:50, David Newall wrote:
>  > > Daniel Phillips wrote:
>  > > > The period where you cannot access the data is downtime.  If your script
>  > > > just does a cp from a disk array to the ram device you cannot just read
>  > > > from the backing store in that period because you will need to fail over
>  > > > to the ramdisk at some point, and you cannot just read from the ramdisk
>  > > > because it is not populated yet.
>  > >
>  > > Wouldn't a raid-1 set comprising disk + ramdisk do that with no downtime?
>  >
>  > In raid1, write completion has to wait for write completion on all
>  > mirror members, so writes run at disk speed.  Reads run at ramdisk
>  > speed, so your proposal sounds useful, but ramback aims for high
>  > write performance as well.
>
>  raid1 + kflushd tweak?
>
>  special raid1 mode that signals completion when it hits _one_ of the
>  drives, and does sync when the slower drive is idle?

raid1 already supports marking member(s) as write-mostly.  Any
write-mostly member can also make use of write-behind mode (provided
you have a write intent bitmap).
