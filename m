Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbXHITyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbXHITyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXHITyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:54:07 -0400
Received: from iona.labri.fr ([147.210.8.143]:50922 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbXHITyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:54:06 -0400
Date: Thu, 9 Aug 2007 21:53:59 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net,
       akpm@google.com
Subject: Re: [PATCH] unicode diacritics support
Message-ID: <20070809195359.GB3676@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linuxconsole-dev@lists.sourceforge.net, akpm@google.com
References: <20070808081010.GA3292@implementation.labri.fr> <20070809124642.fbbd3e68.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070809124642.fbbd3e68.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton, le Thu 09 Aug 2007 12:46:42 -0700, a écrit :
> > Turn the kernel accent_table into unicode, and extend ioctls KDGKBDIACR
> > and KDSKBDIACR into their equivalents KDGKBDIACRUC and KDSKBDIACR.
> > 
> > New function int conv_uni_to_8bit(u32 uni) for converting unicode into 8bit
> > _input_.  No, we don't want to store the translation, as it is potentially
> > sparse and large.
> 
> This changes the kernel ABI a bit.  The KDGKBDIACR ioctl (and friends)
> now return different data.

No, they are still returning data encoded in the consolemap.

What was happening before is that the diacr variable wasn't always
encoded in latin1, it was encoded in the consolemap. Now diacr is always
unicode, so the diacritical translations now have to be translated into
consolemap for the old ioctl() to work as before.

Samuel
