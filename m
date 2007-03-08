Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXCHC1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXCHC1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 21:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXCHC1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 21:27:36 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48074 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXCHC1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 21:27:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Paul Menage" <menage@google.com>
Cc: "Sam Vilain" <sam@vilain.net>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, dev@sw.ru, pj@sgi.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>
	<20070307205846.GB7010@sergelap.austin.ibm.com>
	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	<m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	<6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	<45EF5A62.8000103@vilain.net>
	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	<45EF5E71.7090101@vilain.net>
	<6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	<m1d53ka5b9.fsf@ebiederm.dsl.xmission.com>
	<6599ad830703071735m222e26b7v47a54ca0aaffd902@mail.gmail.com>
Date: Wed, 07 Mar 2007 19:25:54 -0700
In-Reply-To: <6599ad830703071735m222e26b7v47a54ca0aaffd902@mail.gmail.com>
	(Paul Menage's message of "Wed, 7 Mar 2007 17:35:58 -0800")
Message-ID: <m1zm6o8o99.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul Menage" <menage@google.com> writes:

> On 3/7/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> The real trick is that I believe these groupings are designed to be something
>> you can setup on login and then not be able to switch out of.
>
> That's going to to be the case for most resource controllers - is that
> the case for namespaces? (e.g. can any task unshare say its mount
> namespace?)

With namespaces there are secondary issues with unsharing.  Weird things
like a simple unshare might allow you to replace /etc/shadow and thus
mess up a suid root application.

Once people have worked through those secondary issues unsharing of
namespaces is likely allowable (for someone without CAP_SYS_ADMIN).
Although if you pick the truly hierarchical namespaces the pid
namespace unsharing will simply give you a parent of the current
namespace.

For resource controls I expect unsharing is likely to be like the pid
namespace.  You might allow it but if you do you are forced to be a
child and possible there will be hierarchy depth restrictions.
Assuming you can implement hierarchical accounting without to much
expense.



Eric
