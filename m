Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbXBNUlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbXBNUlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXBNUlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:41:49 -0500
Received: from gw.goop.org ([64.81.55.164]:53541 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbXBNUlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:41:49 -0500
Message-ID: <45D3740A.4080600@goop.org>
Date: Wed, 14 Feb 2007 12:41:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>,
       Ian Campbell <Ian.Campbell@XenSource.com>
Subject: Re: [patch 16/21] Xen-paravirt: Add code into head.S to handle being
 booted by Xen
References: <20070213221729.772002682@goop.org>	<20070213221830.707197267@goop.org> <20070213235424.GA1908@muc.de>	<45D35ABE.1050504@goop.org> <m1zm7gpkjh.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1zm7gpkjh.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Well I did a little by hand parsing and the not I parsed looked ok.
>
> How does the output differ from a what you get when xen-head.S is
> included?
>   
Ah!

The .notes section gets SHT_NOTE in vmlinux when xen-head.S is included;
PROGBITS when linked.  I tried putting @note on the .section in
linux/elfnote.h, but that didn't seem to help (xen-note.o got a SHT_NOTE
entry, but it didn't make it into vmlinux).  I couldn't see any way of
forcing the section type in vmlinux.lds; my experiments all ended with
ld dumping core.

    J

