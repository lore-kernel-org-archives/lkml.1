Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbYIKTkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbYIKTkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYIKTkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:40:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45550 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYIKTkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:40:11 -0400
Subject: Re: [PATCH 1/2] audit: fix NUL handling in untrusted strings
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080911121443.c3153842.akpm@linux-foundation.org>
References: <1221085418.2705.19.camel@amilo>
	 <20080911121443.c3153842.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 11 Sep 2008 21:37:47 +0200
Message-Id: <1221161868.17533.37.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton píše v Čt 11. 09. 2008 v 12:14 -0700:
> On Thu, 11 Sep 2008 00:23:38 +0200
> Miloslav Trma__ <mitr@redhat.com> wrote:
> 
> > The audit record can thus contain a NUL byte (and some unchecked data
> > after that).  Because the user-space audit daemon treats audit records
> > as NUL-terminated strings, an untrusted string that is shorter than the
> > specified maximum length effectively terminates the audit record.
> > 

> It's unclear how serious this problem is.
* AUDIT_USER_TTY records (which are sent from user-space with a trailing
NUL byte) are missing a terminating '"' character.
* Some data is not recorded in AUDIT_TTY records, and the terminating
'"' character is missing in that case as well.

>   Do you believe that it is
> sufficiently serious to warrant merging these fixes into 2.6.27? 
> 2.6.26.x?  2.6.25.x?
This patch (1/2) only fixes creation of incorrectly formatted, but
easy-to-understand audit records; it would be nice to have it in 2.6.27
(assuming the audit maintainer acks it - or a variant of it).  The other
one (2/2), which makes sure all TTY audit data is recorded, should
probably be merged in the stable releases as well.
	Mirek

