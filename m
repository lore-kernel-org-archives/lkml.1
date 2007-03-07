Return-Path: <linux-kernel-owner+w=401wt.eu-S965730AbXCGXPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965730AbXCGXPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965731AbXCGXPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:15:09 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42689 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965726AbXCGXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:15:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <hansendc@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, pj@sgi.com, winget@google.com, containers@lists.osdl.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>
	<6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	<20070307173031.GC2336@in.ibm.com>
	<20070307174346.GA19521@sergelap.austin.ibm.com>
	<20070307180055.GC17151@in.ibm.com>
	<20070307205846.GB7010@sergelap.austin.ibm.com>
	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	<20070307215919.GA2110@sergelap.austin.ibm.com>
	<1173305626.868.10.camel@localhost.localdomain>
Date: Wed, 07 Mar 2007 16:13:15 -0700
In-Reply-To: <1173305626.868.10.camel@localhost.localdomain> (Dave Hansen's
	message of "Wed, 07 Mar 2007 14:13:46 -0800")
Message-ID: <m1abyobqb8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <hansendc@us.ibm.com> writes:

> On Wed, 2007-03-07 at 15:59 -0600, Serge E. Hallyn wrote:
>> Space saving was the only reason for nsproxy to exist.
>> 
>> Now of course it also provides the teensiest reduction in # instructions
>> since every clone results in just one reference count inc for the
>> nsproxy rather than one for each namespace. 
>
> If we have 7 or 8 namespaces, then it can save us a significant number
> of atomic instructions on _each_ of the refcounts, plus touching all of
> the cachelines, etc...

Well we still have a global lock on the fork path so there is only so
much we can do to improve things.  The global process list, and there
are some interesting posix signal handling rules that limit how much
we can relax that restriction.

However with namespaces we have a natural limit on how many we will
have.  There aren't that many spaces for global names.

I don't know the situation well enough for resource controllers but I
suspect we might not have any kind of natural limit (except what a
single person can comprehend) to the kind of resource we will
ultimately want to control which tends to imply we will have more of those.  

Eric
