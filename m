Return-Path: <linux-kernel-owner+w=401wt.eu-S932752AbXA1TPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbXA1TPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932754AbXA1TPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:15:54 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:42312 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbXA1TPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:15:53 -0500
Date: Sun, 28 Jan 2007 11:11:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: 7eggert@gmx.de
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andrew Morton <akpm@osdl.org>,
       Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] readahead: state based method routines: explicitly
 embed class_new/class_old inside flags
Message-Id: <20070128111104.789cbd07.randy.dunlap@oracle.com>
In-Reply-To: <E1HAmF2-0000cV-Ux@be1.lrz>
References: <7HR6P-3Wm-3@gated-at.bofh.it>
	<7HR6S-3Wm-13@gated-at.bofh.it>
	<E1HAmF2-0000cV-Ux@be1.lrz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 13:01:08 +0100 Bodo Eggert wrote:

> Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > The new/old ra class were implicitly stored in low bits of
> > file_ra_state.flags. Now make the data structure obvious, and remove the
> > coding tricks.
> 
> > +++ linux-2.6.20-rc4-mm1/include/linux/fs.h
> 
> > -     unsigned long flags;    /* RA_FLAG_xxx | ra_class_old | ra_class_new */
> > +     union {
> > +             unsigned long   flags;  /* RA_FLAG_xxx | class_old | class_new */
> > +             struct {
> > +                     u8      class_new;
> > +                     u8      class_old;
> 
> This doesn't work on big endiam machines, does it?
> 
> IMO you should use a bitfield instead.

Or "use bit masks instead" since

"The order of allocation of bit-fields within a unit (high-order to
low-order or low-order to high-order) is implementation-defined."

---
~Randy
