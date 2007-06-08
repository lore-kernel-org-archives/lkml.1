Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbXFHEC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbXFHEC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 00:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXFHECU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 00:02:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51470 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbXFHECT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 00:02:19 -0400
Message-ID: <4668D4A9.1000905@zytor.com>
Date: Thu, 07 Jun 2007 21:01:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
References: <20070606225837.654272428@goop.org> <20070606230922.476662240@goop.org> <4667462A.2010404@zytor.com> <466749C8.2010700@goop.org> <46674C96.7090104@zytor.com> <46674F68.6030100@goop.org> <4667547B.8080502@zytor.com> <20070608034958.GA10728@in.ibm.com>
In-Reply-To: <20070608034958.GA10728@in.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> 
> One would not know highest used address until ELF headers have been 
> parsed. May be it is two step movement. First decompress ELF.gz and 
> ELF parser can be at the end of decompressed data. Then it can parse
> the ELF headers and move itself out of the ELF header destination memory
> and then load the elf segments at appropriate place.
> 
> One will have to be little careful while moving ELF parser or while
> decompressing the file to a temporary buffer so that we don't stomp over
> any other data loaded by boot-loader (like kexec does) or we don't go beyond
> the memory bounds which might have been created in the case of using kdump.
> 

The easiest is probably to decode the ELF headers (which can be done in
O(1) space), relocate, reset the decompressor and restart.

Relocation is currently done in the decompressor, but it could also be
done at the kernel entrypoint, as long as the kernel entrypoint code is
all PIC.

	-hpa
