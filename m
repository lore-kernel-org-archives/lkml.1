Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZDXUDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZDXUDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 16:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZDXUCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:02:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47948 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752649AbZDXUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:02:54 -0400
Date: Fri, 24 Apr 2009 16:02:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
cc: USB list <linux-usb@vger.kernel.org>
Subject: NLS: utf8 conversions
Message-ID: <Pine.LNX.4.44L0.0904241534110.4531-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although nobody seems to have made a big deal about it, the conversions
between utf8 and utf16 done by fs/nls/nls_base.c are wrong in a couple
of important respects:

	They don't handle Unicode code points larger than U+FFFF.

	They don't detect invalid values, in particular, surrogate
	code points.

The problems stem from the fact the characters at issue can't be
represented by a single 16-bit wchar_t.  But that's no excuse for
performing an incorrect conversion to or from utf16.

Are there any definite thoughts on how this should be handled?  I don't 
see any way for the single-character conversion routines (utf8_mbtowc 
and utf8_wctomb) to come to grips with these issues, except perhaps for 
returning an error when a character would be invalid or too big to fit 
in 16 bits.

The string-oriented routines (utf8_mbstowcs and utf8_wcstombs) could be 
adapted to deal with these issues properly.

Any comments or suggestions for other approaches?

Alan Stern

