Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZAGOki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZAGOki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZAGOkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:40:06 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:35096 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784AbZAGOkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:40:05 -0500
Message-Id: <4964CCEE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 07 Jan 2009 14:40:30 +0000
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
 <4964CA0A.76E4.0078.0@novell.com>
 <20090107143711.GW28946@ZenIV.linux.org.uk>
In-Reply-To: <20090107143711.GW28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Al Viro <viro@ZenIV.linux.org.uk> 07.01.09 15:37 >>>
>On Wed, Jan 07, 2009 at 02:28:10PM +0000, Jan Beulich wrote:
>> >	b) is there any reason why we can't copy symbol table out of module
>> >ourselves (instead of setting SHF_ALLOC on it) and trim the crap out of
>> >it?  Note that __crc_... is not the only junk in there - you don't need
>> >(or want) to keep the things like undefs for /proc/kallsyms purposes.
>> >And modules *using* an exported symbol are more common that modules exporting
>> >one...  Why not copy it at add_kallsyms() time, skipping the junk we don't
>> >want anyway?
>> 
>> Would certainly be doable, but would seem reasonable only if it's a small
>> set of easily recognizable symbols. If you look at scripts/strip-symbols,
>> you may agree that it's better to do this at build time...
>
>I will not.  Undefined ones are far more common than any of those...

Undefined ones could certainly be stripped out there (while they definitely
can't be at build time).

Jan

