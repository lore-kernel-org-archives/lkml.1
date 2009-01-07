Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZAGO1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZAGO1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZAGO1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:27:43 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:34661 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbZAGO1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:27:43 -0500
Message-Id: <4964CA0A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 07 Jan 2009 14:28:10 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Al Viro" <viro@ZenIV.linux.org.uk>
Cc: <ccache@lists.samba.org>, "Theodore Ts'o" <tytso@mit.edu>,
       "Sam Ravnborg" <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Recent change to kernel spikes out
	 ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
 <20090107051027.GU28946@ZenIV.linux.org.uk>
 <49647A9E.76E4.0078.0@novell.com>
 <20090107140328.GV28946@ZenIV.linux.org.uk>
In-Reply-To: <20090107140328.GV28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Al Viro <viro@ZenIV.linux.org.uk> 07.01.09 15:03 >>>
>I do not understand two things.
>	a) WTF would we care about ones in vmlinux, when kallsyms drops the
>absolute ones anyway?

The patch is not only about __crc_* - for vmlinux, this part really doesn't
matter, but there's a significant amount of other symbols that get stripped
from vmlinux with the second patch.

>	b) is there any reason why we can't copy symbol table out of module
>ourselves (instead of setting SHF_ALLOC on it) and trim the crap out of
>it?  Note that __crc_... is not the only junk in there - you don't need
>(or want) to keep the things like undefs for /proc/kallsyms purposes.
>And modules *using* an exported symbol are more common that modules exporting
>one...  Why not copy it at add_kallsyms() time, skipping the junk we don't
>want anyway?

Would certainly be doable, but would seem reasonable only if it's a small
set of easily recognizable symbols. If you look at scripts/strip-symbols,
you may agree that it's better to do this at build time...

Jan

