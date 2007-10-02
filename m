Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbXJBXq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbXJBXq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXJBXqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:46:49 -0400
Received: from gw.goop.org ([64.81.55.164]:58944 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbXJBXqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:46:48 -0400
Message-ID: <4702D867.2060100@goop.org>
Date: Tue, 02 Oct 2007 16:46:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       lguest <lguest@ozlabs.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] Boot protocol changes
References: <1191368052.17826.40.camel@localhost.localdomain>
In-Reply-To: <1191368052.17826.40.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Hi all,
>
> 	Jeremy had some boot changes for bzImages, but buried in there was an
> update to the boot protocol to support Xen and lguest (and kvm-lite).
> I've copied those fairly simple patches, and if HPA is happy I'd like to
> push them for 2.6.24 (after correcting for the Great Arch Merge of
> course).

Ah, good.  I was thinking about reviving this work.  The main problem is
that sticking an ELF header at the 1 meg mark (the address of the
bzImage "payload") breaks 32-bit bootloaders which think they can just
jump to 32-bit code there.  I started a conversation with Eric at KS
about it, but we didn't reach any conclusions.

This series looks like a good start for Xen, but we still need to work
out where to stash the metadata which normally lives in ELF notes.  
Using ELF is convenient for Xen because it lets a large chunk of domain
builder code be reused; on the other hand, loading a plain bzImage is
pretty simple, so maybe it isn't such a big deal.

HPA, Eric: if we don't go the "embed ELF" path, where's a good
backwards-compatible place to stash the note data?  If we do go with
"embed ELF", how should we go about doing it?  Arrange to put the ELF
headers before the 1M mark?

    J
