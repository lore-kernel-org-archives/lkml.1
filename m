Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZAGNrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZAGNrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZAGNrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:47:37 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:32805 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZAGNrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:47:36 -0500
Message-Id: <4964C0A3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 07 Jan 2009 13:48:03 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <ccache@lists.samba.org>, "Theodore Tso" <tytso@mit.edu>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Recent change to kernel spikes out
	 ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
 <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu>
 <49647B00.76E4.0078.0@novell.com>
 <20090107113138.GA29730@uranus.ravnborg.org>
 <4964AF8D.76E4.0078.0@novell.com>
 <20090107132337.GA2289@uranus.ravnborg.org>
In-Reply-To: <20090107132337.GA2289@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sam Ravnborg <sam@ravnborg.org> 07.01.09 14:23 >>>
>On Wed, Jan 07, 2009 at 12:35:09PM +0000, Jan Beulich wrote:
>> >>> Sam Ravnborg <sam@ravnborg.org> 07.01.09 12:31 >>>
>> >What is the gain/pain ratio here?
>> 
>> Certainly depends on the pov - it reduces the kernel module (disk) image
>> sizes quite a bit, so from a distro perspective its a move against the ever
>> growing package sizes (and the disk space) hundreds or even thousands
>> of modules require.
>
>The kernel modules seldom export anything so the benefit is minimal here.

Not really, for highly modular distro kernels.

>I did a 15 minutes hack to try ripping the .c -> .s -> .o stuff out.

Looks good to me. In case you decide to revert the stuff for .29, I'll
merge this into my patch.

>Jan - I need some hard numbers to convince me that stripping the
>__crc symbols is worth it.

The on-disk size of the modules in my builds is reduced by about 5% with
this patch (but I can't immediately tell how much of this is due to __crc_*
vs. other symbol stripping).

Jan

