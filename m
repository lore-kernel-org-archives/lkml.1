Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbYBZJRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbYBZJRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbYBZJQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:16:49 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:38022 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760962AbYBZJQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:16:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=S74msBETVOe1CeQrIAVYUa+cPSgFoKxv6dvSrUY0zUeoeqL12BDEWkwzF+plWIrPFswKaxkwfYMm9C9Y+Gv4wGYww/G6h0ccFKd9GRmCYRYjzg6bNl8P+Y+UIRWDgSxwQdJnMBW6IDKYmGi64CAwN0Gn6YniGq/XpNxfr+ERoTA=  ;
X-YMail-OSG: wBemi44VM1nZsOaIhGCbMHofoWx_PAQA4Qj.IBIwd.BZ4g33rMEPHUOu8JwaCpOKKCMlSSmY8Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Tue, 26 Feb 2008 01:16:17 -0800
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802251439030.5536-100000@iolanthe.rowland.org> <200802252313.23399.david-b@pacbell.net> <47C3CD15.1060908@davidnewall.com>
In-Reply-To: <47C3CD15.1060908@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260116.18142.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008, David Newall wrote:
> 
> Hardware can be inserted and removed while we're in a suspend state; and
> there's nothing that we can do about it until we resume.  Is it fair to
> say, then, that having started suspend, we could reasonably ignore any
> device insertion and removal, and handle it on resume?

"Ignore" seems a bit strong; those events may be wakeup triggers,
which would cause the hardware to make it a very short suspend state.

"Defer handling" is more to the point, be it by hardware or software.


> Presumably we need to scan for hardware changes on resume.

Not on most busses I work with; the hardware issues notifications
whenever the devices are removable.

Which is a Good Thing ... scanning, as you suggest, is inherently
not reliable.  If a mouse is swapped, it likely doesn't matter a
lot whether it's the "same" or not.

But ... how about if some removable storage media was taken out,
updated on a different system, then restored before the resume?
Not many filesystems handle that sanely.  You *really* want to
have hardware which reports disconnect/reconnect events, or which
physically prevents them (locked case etc).

- Dave



