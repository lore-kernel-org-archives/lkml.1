Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbYBHIOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbYBHIOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYBHIOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:14:03 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:47992
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbYBHIOB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:14:01 -0500
Message-Id: <47AC1D63.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 08 Feb 2008 08:14:11 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>, "Chuck Ebbert" <cebbert@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, "Al Viro" <viro@ZenIV.linux.org.uk>
Subject: Re: section breakage on ppc64 (aka __devinitconst is broken by
	design)
References: <20080203130844.GS27894@ZenIV.linux.org.uk>
 <47AB4F0E.3050907@redhat.com> <20080207185409.GA21145@uranus.ravnborg.org>
In-Reply-To: <20080207185409.GA21145@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I cannot see any other way out of this than to loose all the newly added
>consts. We have to different behavior across platforms to find a suitable
>solution that is reliable.
>
>[Kept rest of mail as I added Jan - hope he have some ideas to throw in].

I'd first of all need a better understanding of what these comments are
really based upon:

/* On some platforms relocations to global data cannot go into read-only
   sections, so 'const' makes no sense and even causes compile failures
   with some compilers. */

While I can see such behavior as reasonable for, say, shared objects,
I severely doubt that this is generally appropriate for executables, not
to say for the kernel. This is particularly in the light of this comment in
gcc/output.h:

  /* To optimize loading of shared programs, define following subsections
     of data section:

which clearly says that the resulting (default) object placement (of read-
only data in writeable sections) is an optimization, not a requirement,
and even then only for shared programs (which the kernel clearly isn't).
Has there been any communication with the gcc folks on this subject?

Jan

