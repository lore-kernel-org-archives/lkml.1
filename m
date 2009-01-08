Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbZAHJ2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbZAHJ2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZAHJ2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:28:19 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:16681 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbZAHJ2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:28:17 -0500
Message-Id: <4965D55C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 08 Jan 2009 09:28:44 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Al Viro" <viro@ZenIV.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       <rostedt@goodmis.org>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "sparclinux" <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
References: <20090105181922.GA25622@uranus.ravnborg.org>
 <20090105194844.GR28946@ZenIV.linux.org.uk>
 <20090105195523.GB6204@uranus.ravnborg.org>
 <49631BF0.76E4.0078.0@novell.com>
 <20090106113543.GS28946@ZenIV.linux.org.uk>
In-Reply-To: <20090106113543.GS28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Al Viro <viro@ZenIV.linux.org.uk> 06.01.09 12:35 >>>
>On Tue, Jan 06, 2009 at 07:53:04AM +0000, Jan Beulich wrote:
>> The others look like a tools side behavioral difference, as I never saw any
>> such. Is this problem sparc32-specific (I tested x86 and ia64 only)? What's
>> the binutils version used?
>
>2.18.50.0.6.
>
>And no, it's not tools side.  What it is, AFAICT, is that sparc32 has
>LDFLAGS_vmlinux = -r, which leaves a metric arseload of relocs that
>wouldn't have survived into vmlinux otherwise.  Look at .rela__ksymtab
>in .tmp_vmlinux1, for example...

So that should help:

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -588,6 +588,8 @@
 config KALLSYMS_STRIP_GENERATED
 	bool "Strip machine generated symbols from kallsyms"
 	depends on KALLSYMS_ALL
+	# This doesn't work with -r in LDFLAGS_vmlinux.
+	depends on !SPARC || SPARC64
 	default y
 	help
 	  Say N if you want kallsyms to retain even machine generated symbols.


