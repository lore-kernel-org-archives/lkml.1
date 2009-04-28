Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbZD1Pvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbZD1Pvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZD1Pvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:51:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39173 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754776AbZD1Pvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:51:43 -0400
Date: Tue, 28 Apr 2009 11:51:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Clemens Ladisch <clemens@ladisch.de>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: NLS: utf8 conversions
In-Reply-To: <49F6A756.7070203@ladisch.de>
Message-ID: <Pine.LNX.4.44L0.0904281148410.670-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Clemens Ladisch wrote:

> Alan Stern wrote:
> > Your comments agree pretty well with what I had concluded.  However a 
> > lot of the source files have lengthy tables of wchar_t values; changing 
> > them to 32 bits would waste a lot of space.
> > 
> > As a sort of compromise, I came up with this patch (not tested yet,
> > although it compiles okay).  How does it look to you?
> 
> From a not-having-it-tested-either perspective, it looks good.
> 
> > +utf8_to_utf32(unicode_t *p, const u8 *s, int n)
> > +utf32_to_utf8(u8 *s, unicode_t u, int maxlen)
> > +utf8s_to_utf16s(wchar_t *pwcs, const u8 *s, int n)
> > +utf16s_to_utf8s(u8 *s, const wchar_t *pwcs, int maxlen, int inlen,
> 
> Minor nitpick: You already have enhanced the insane parameter ordering
> of wcsntombs_be(), but the meaning of all these functions' parameters
> would be even more obvious if the buffer size would immediately follow
> the corresponding buffer pointer.

Since these routines are used in so few places, I can easily change the
parameter ordering to something more reasonable (like uni2char and
char2uni, for example).

> Anyway,
> Acked-by: Clemens Ladisch <clemens@ladisch.de>

Thanks for the review.

Alan Stern

