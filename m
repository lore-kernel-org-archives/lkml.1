Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbXJKO43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbXJKO43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 10:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXJKO4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 10:56:22 -0400
Received: from mlbe2k1.cs.myharris.net ([137.237.90.88]:37809 "EHLO
	mlbe2k1.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbXJKO4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:56:21 -0400
X-Greylist: delayed 1149 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 10:56:21 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: Aggregation in embedded context, is kernel GPL2 prejudice against embedded systems?
Date: Thu, 11 Oct 2007 10:33:28 -0400
Message-ID: <E496871456016F4CA8959BE4105D2A890E8D76@troe2k1.cs.myharris.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Aggregation in embedded context, is kernel GPL2 prejudice against embedded systems?
Thread-Index: AcgME6yRG7bRgvFlSzu/wSQBhH4dOA==
From: "Crane, Matthew" <mcrane03@harris.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Oct 2007 14:33:30.0019 (UTC) FILETIME=[B1657F30:01C80C13]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


>From the GPL FAQ:
===
What is the difference between "mere aggregation" and "combining two
modules into one program"? 
	Mere aggregation of two programs means putting them side by side
on the same CD-ROM or hard disk. We use this term in the case where they
are separate programs, not parts of a single program. In this case, if
one of the programs is covered by the GPL, it has no effect on the other
program. 
	Combining two modules means connecting them together so that
they form a single larger program. If either part is covered by the GPL,
the whole combination must also be released under the GPL--if you can't,
or won't, do that, you may not combine them.
	What constitutes combining two parts into one program? This is a
legal question, which ultimately judges will decide. We believe that a
proper criterion depends both on the mechanism of communication (exec,
pipes, rpc, function calls within a shared address space, etc.) and the
semantics of the communication (what kinds of information are
interchanged).
	If the modules are included in the same executable file, they
are definitely combined in one program. If modules are designed to run
linked together in a shared address space, that almost surely means
combining them into one program.
	By contrast, pipes, sockets and command-line arguments are
communication mechanisms normally used between two separate programs. So
when they are used for communication, the modules normally are separate
programs. But if the semantics of the communication are intimate enough,
exchanging complex internal data structures, that too could be a basis
to consider the two parts as combined into a larger program. 
=== 

The typical mechanisms of aggregation in desktop systems are much
different then embedded systems.   Embedded systems often do not have
room for pipes, sockets, and loadable modules.   Static linking may be
the only practical means of building a kernel image in such systems.   A
good example of this would be the extensive use of busybox, where many
programs have been aggregated into a single binary.  The same utilities
are normally separate on desktop systems.  It is also typical of
embedded devel to link the a low-level app directly to the OS where
drivers are normally modules in desktops.

If that is what is normal for embedded systems, wouldn't the expectation
of what is reasonable for "mere aggregation" be similarly different?
I've read much FUD about how anything linked statically is instantly a
derived work.   I do not think it is so black and white.  To me this
seems to pre-suppose that the option to load modules dynamically always
exists.   I do believe that if it does exist, it should be taken, and
that the interface boundaries always need to be respected regardless, to
the point of not using kernel headers and limiting the number of calls
to EXPORT_SYMBOL functions to the absolute minimum.

So would the persons responsible for defending the kernel GPL make
allowance for the minimal options for separation in a system so resource
constrained that it makes sense only to link statically?  I am trying to
make a case that this is ok because that is what systems similar in hw
specs generally due to save resources, and that many examples of an
"embedded" style of aggregation exist.

I'm also wondering if current Linksys WRT54G packaging may be used as a
model for building embedded Linux systems with some closed source.
According to wikipedia "The WRT54G is notable for being the first
consumer-level network device that had its firmware source code released
to satisfy the obligations of the GNU GPL".  I notice they still have
multiple binary objects that link to the kernel in a final image. 

Thanks for any feedback, cheers,


Matt
