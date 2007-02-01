Return-Path: <linux-kernel-owner+w=401wt.eu-S1422836AbXBAMjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422836AbXBAMjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 07:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422838AbXBAMjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 07:39:17 -0500
Received: from gockel.physik3.uni-rostock.de ([139.30.44.16]:9929 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422836AbXBAMjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 07:39:16 -0500
Date: Thu, 1 Feb 2007 13:39:15 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: David Howells <dhowells@redhat.com>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h. 
In-Reply-To: <3565.1170326639@redhat.com>
Message-ID: <Pine.LNX.4.63.0702011336490.15668@gockel.physik3.uni-rostock.de>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
  <3565.1170326639@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, David Howells wrote:
> Robert P. J. Day <rpjday@mindspring.com> wrote:
> 
> > +#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))
> 
> If this is such a commonly implemented op, it should probably be implemented
> globally too.
> 
> I also wonder if there's some better way of implementing it than this, but I
> can't think of one offhand.

#define is_power_of_2_or_zero(x) ((x & (x-1))==0)
#define is_power_of_4(x) (is_power_of_2_or_zero(x) \
                          && (x & ((typeof(x))0x55555555)))

?

Tim
