Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZAGItA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZAGItA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZAGIsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:48:52 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:18644 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbZAGIsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:48:51 -0500
Message-Id: <49647A9E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 07 Jan 2009 08:49:18 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Al Viro" <viro@ZenIV.linux.org.uk>
Cc: <ccache@lists.samba.org>, "Theodore Ts'o" <tytso@mit.edu>,
       "Sam Ravnborg" <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Recent change to kernel spikes out
	 ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
 <20090107051027.GU28946@ZenIV.linux.org.uk>
In-Reply-To: <20090107051027.GU28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Al Viro <viro@ZenIV.linux.org.uk> 07.01.09 06:10 >>>
>On Tue, Jan 06, 2009 at 10:15:26AM -0500, Theodore Ts'o wrote:
>> Or, if that's too complicated, maybe it would be worthwhile to have
>> kbuild create its own specialized ccache system?  Note that the last two
>> solutions rule out using distcc, unless we can encapsulate the build
>> process from a series of Makefile macros to a shell or C program, which
>> could then be injected to the remote host system to be executed by
>> distcc.  One value of doing that is the CRC or MD5 of the shell script
>> could be used as the version tag for the cache system.
>
>Ho-hum...  Could somebody explain why the hell had we switched to this
>"intermediate .s" approach, anyway?  It's not as if we couldn't run
>objcopy after what we used to do...

Because objcopy wouldn't remove the __crc_* symbols the way the
object files were generated previously. I explored all possibilities I could
think of, with that two step process being the last, but the only one that
had the intended effect. In the end I queried the binutils list, and got
confirmation that there's no (existing) way to get rid of symbols used in
relocations in an already existing object file without corrupting it.

Jan

