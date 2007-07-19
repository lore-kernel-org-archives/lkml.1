Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbXGSGtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbXGSGtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933120AbXGSGtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:49:11 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:33175 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762966AbXGSGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:49:09 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Date: Thu, 19 Jul 2007 08:49:05 +0200
User-Agent: KMail/1.9.4
Cc: TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070715.210036.157242351.takada@mbf.nifty.com> <200707152106.28437.juergen127@kreuzholzen.de> <20070718180223.e1dad55d.akpm@linux-foundation.org>
In-Reply-To: <20070718180223.e1dad55d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190849.05983.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 03:02, Andrew Morton wrote:
> On Sun, 15 Jul 2007 21:06:27 +0200
>
> Juergen Beisert <juergen127@kreuzholzen.de> wrote:
> > Replace NSC/Cyrix specific chipset access macros by inlined functions.
> > With the macros a line like this fails (and does nothing):
> > 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> > With inlined functions this line will work as expected.
>
> I don't get it.  Why would the macros behave differently from inlined
> functions?

X86 magic. The access order is important. The first access must always be the 
offset at 0x22. This access enables the next access to 0x23 (data). If you do 
it in wrong order, it fails. With the macros you get something like 0x22, 
0x22, 0x23, 0x23. With the inline functions 0x22,0x23,0x22,0x23.

Juergen
