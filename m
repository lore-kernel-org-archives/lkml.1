Return-Path: <linux-kernel-owner+w=401wt.eu-S966260AbXFGAnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966260AbXFGAnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXFGAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:42:55 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbXFGAmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:42:54 -0400
Message-ID: <4667547B.8080502@zytor.com>
Date: Wed, 06 Jun 2007 17:42:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
References: <20070606225837.654272428@goop.org> <20070606230922.476662240@goop.org> <4667462A.2010404@zytor.com> <466749C8.2010700@goop.org> <46674C96.7090104@zytor.com> <46674F68.6030100@goop.org>
In-Reply-To: <46674F68.6030100@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Certainly, but much harder to implement.  The ELF parser needs to be
> prepared to move itself around to get out of the way of the ELF file. 
> It's a fairly large change from how it works now.
> 

It doesn't if we simply declare that a certain chunk of memory is
available to it, for the case where it runs in the native configuration.
Since it doesn't have to support *any* ELF file, just the kernel one,
that's an option.

On the other hand, I guess with the decompressor/ELF parser being PIC,
one would simply look for the highest used address, and relocate itself
above that point.  It's not really all that different from what the
decompressor does today, except that it knows the address a priori.

> I was thinking of making the ELF file entirely descriptive, since its
> just a set of ELF headers inserted into the existing bzImage structure,
> and it still relies on the bzImage being build properly in the first place.

Again, it's an option.  The downside is that you don't get the automatic
test coverage of having it be exercised as often as possible.

	-hpa

