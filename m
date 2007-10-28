Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbXJ1Mqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbXJ1Mqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 08:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbXJ1Mqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 08:46:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:25683 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXJ1Mqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 08:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b8+oyjqBlWtbmrW1Q1pQbFdfcOVymjns6h99BgPiO7JnnNeRV8SJMJMkxAIsZG/+F6Auj+fsJ2tnfe85wu8a5vQbqNJZOxDNdQTFIDkEA4aE2QTcgfX2jE4hHFRojmc0C92MqYbwqWs7JpSYtxUTdaYFVMqIJ3efAuO2p+AnPmg=
Message-ID: <1865922a0710280546n40de6e4exe8b43ce2e444366d@mail.gmail.com>
Date: Sun, 28 Oct 2007 14:46:36 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 2/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory Access Control Kernel
Cc: casey@schaufler-ca.com, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071027234719.GU8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4720118C.5020906@schaufler-ca.com> <20071027090112.GA5460@Ahmed>
	 <20071027234719.GU8181@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Sat, Oct 27, 2007 at 11:01:12AM +0200, Ahmed S. Darwish wrote:
> > The problem here (As discussed in private mails) is that the for loop
> > assumes that the beginning of given user-space buffer is the beginning
> > of a rule. This leads to situations where the rule becomes "ecret 20",
> > or "cret 20" instead of "Secret 20". Big input buffers/files leads
> > smack to recieve a rule like "Secret 20" in fragmented chunks like:
> >
> > write("<lots of rules before ours>\nSec", ..)
> > write("r", 1, ..)
> > write("et 20\n<remaing rules after ours>", ..)
> >
> > Parsing a rule in such tough conditions in _kernel space_ is very
> > hard. I began to feel that it will be much easier if we do the parsing
> > in a userspace utility and let smack accept only small buffers (80 char).
>
> For crying out louf, all it takes is a finite state machine...  BTW, folks,
> your parser *and* input language suck.  Really.  Silently allowing noise
> is Dumb(tm).
>

Ehem .., I really thought about the FSM thing but I thought it won't
be possible with concurrent writes (forgetting that several related
writes is done in one open(),release() session and we can lock writes
in open()).

<Getting back to coding>

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
