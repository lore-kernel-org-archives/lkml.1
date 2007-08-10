Return-Path: <linux-kernel-owner+w=401wt.eu-S939376AbXHJPP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939376AbXHJPP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXHJPPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:15:48 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:1754 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbXHJPPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:15:47 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=oNL7p9QczYnxrlY6m9fVkJQJJi7xHxxH+WFq+CNhvIi/EGPJE4q8SxAR2cXzyAP3eYffveqXnhMHat2/TKlSKiP2BgVzISmMjQ9fE/Rbmjv+WxywYBt/HGMiz3xoi1so;
X-IronPort-AV: E=Sophos;i="4.19,245,1183352400"; 
   d="scan'208";a="336311852"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: EHCI Regression in 2.6.23-rc2
Date: Fri, 10 Aug 2007 10:14:56 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9B18E19@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <Pine.LNX.4.64.0708101125120.3948@twin.jikos.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: EHCI Regression in 2.6.23-rc2
Thread-Index: AcfbMMIM8i7lO3aDT2KzSiwnsHr4ugAL0OEg
References: <200708101045.57166.dex@dragonslave.de> <Pine.LNX.4.64.0708101125120.3948@twin.jikos.cz>
From: <Stuart_Hayes@Dell.com>
To: <jikos@jikos.cz>, <webmaster@dragonslave.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 10 Aug 2007 15:15:29.0672 (UTC) FILETIME=[499D8880:01C7DB61]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 10 Aug 2007, Daniel Exner wrote:
> 
>> After some serious hangs with 2.6.23-rc2 I did some bisects and this
>> was the result:
>> 196705c9bbc03540429b0f7cf9ee35c2f928a534 is first bad commit commit
>> 196705c9bbc03540429b0f7cf9ee35c2f928a534
>> Author: Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
>> Date:   Thu May 3 08:58:49 2007 -0700
> 
> I guess that the patch attached to bug 8535 in kernel.org bugzilla --
> http://bugzilla.kernel.org/attachment.cgi?id=12228&action=view --
> solves your issues, right?  
> 
> Stuart, did you submit this fix for upstream already please?

Yes... http://marc.info/?l=linux-usb-devel&m=118598561010046&w=2

However, I have not tested this with a VIA EHCI controller (though it's
been tested with Intel, Broadcom, and nVidia).  This patch uses the
"inactivate" bit in the QH, which wasn't previously used by the linux
kernel, and I found that the different vendors of EHCI controllers
(Intel, Broadcom, nVidia) all handle this a little differently.  There's
probably something about the way VIA controllers respond to seeing this
bit set that is breaking things.

I'll try to get my hands on a VIA EHCI controller so I can look at
this... if you happen to know of an add-in card that has one of these,
please let me know!  It would be a lot easier for me to debug this
myself here than to try to get someone else to run test kernels for
me...
