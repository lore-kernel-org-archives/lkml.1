Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbZKGLJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbZKGLJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 06:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZKGLJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 06:09:27 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41765 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZKGLJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 06:09:25 -0500
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: pavel@ucw.cz, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, dhowells@redhat.com, hch@infradead.org,
       adilger@sun.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
	<20091105131545.72b4e319@lxorguk.ukuu.org.uk>
	<E1N63Io-000353-KX@pomaz-ex.szeredi.hu> <20091106141742.GA1428@ucw.cz>
	<m17hu3xtiy.fsf@fess.ebiederm.org>
	<E1N6g3B-0006UZ-1R@pomaz-ex.szeredi.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 07 Nov 2009 03:09:18 -0800
In-Reply-To: <E1N6g3B-0006UZ-1R@pomaz-ex.szeredi.hu> (Miklos Szeredi's message of "Sat\, 07 Nov 2009 08\:49\:33 +0100")
Message-ID: <m13a4qsiap.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Fri, 06 Nov 2009, ebiederm@xmission.com (Eric W. Biederman wrote:
>> So far no one who believes this to be a security hole has found it
>> worth their while to look at nd->intent.open in proc_pid_follow_link
>> and write a patch.
>
> A rather disgusting patch that would be.  The fact is, checking
> permissions on follow_link makes little to no sense.  Consider
> truncate(2), for example.  Will we add another intent for that?  I
> really hope not

No.  I was just thinking we have the open intent that is there for
combining lookup and open. We can look test for LOOKUP_OPEN and do
exactly what we need.

> I'm more and more convinced, that the current behavior is the right
> one.

I think the 15 or so years we have had the current behavior without
problems is persuasive.

I think it is an interesting puzzle on how to get dup instead of
reopen as there are cases where that could be useful behavior as well.

The usefulness of an O_NONE flag increases significantly if you can
open the reference file later with more permissions.  Essentially
making a hardlink into a running program.  Hmm.  Weird cases do seem
to show up when the last dir entry is removed.  

I wonder if we want a rule that you can't open a file with link count
of 0.  Reasoning may get truly strange otherwise.

Eric
