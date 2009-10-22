Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZJVSJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZJVSJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 14:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZJVSJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 14:09:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51098 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbZJVSJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 14:09:28 -0400
Date: Thu, 22 Oct 2009 11:10:47 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: mtk.manpages@gmail.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Helsley <matthltc@us.ibm.com>,
       randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Message-ID: <20091022181047.GA21628@us.ibm.com>
References: <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com> <20091019174405.GE27627@count0.beaverton.ibm.com> <4ADCDAA8.5080408@zytor.com> <20091019235012.GF27627@count0.beaverton.ibm.com> <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com> <4ADF06B7.50508@zytor.com> <20091021194440.GA1283@us.ibm.com> <cfd18e0f0910220340n7c655daap78e395136c56f882@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <cfd18e0f0910220340n7c655daap78e395136c56f882@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk [mtk.manpages@googlemail.com] wrote:
| Sukadev,
| 
| On Wed, Oct 21, 2009 at 9:44 PM, Sukadev Bhattiprolu
| <sukadev@linux.vnet.ibm.com> wrote:
| > H. Peter Anvin [hpa@zytor.com] wrote:
| >> On 10/21/2009 01:26 PM, Michael Kerrisk wrote:
| >>>
| >>> My question here is: what does "3" actually mean? In general, system
| >>> calls have not followed any convention of numbering to indicate
| >>> successive versions -- clone2() being the one possible exception that
| >>> I know of.
| >>>
| >>
| >> "3" is number of arguments.
| >
| > To me, it is a version number.
| 
| See my precending mail. Isn't the number of arguments "2".

Well it was 2 at one point, but I have posted a new version of
just that one patch - please see http://lkml.org/lkml/2009/10/16/3
for comments.

I am working on some updates and will post a new patchset - it
will have 3 parameters to clone3() as shown in the above mail.

| 
| > mmap() and mmap2() both have 6 parameters.
| >
| > Besides if wait4() were born before wait3(), would it still be wait4() :-)
| > But I see that it is hard to get one-convention-that-fits-all.
| 
| Yes -- that's exactly right.
| 
| >> It's better than "extended" or something
| >> like that simply because "extended" just means "more than", and a number
| >> at least tells you *how much more than*.
| >
| > And extended assumes we wont extend again.
| 
| Well, if we do things right in this design, we may not need to ever
| extend (by creating a new syscall) again. That's why I mentioned the
| "flags" argument idea. Did you give this some thought?

Yes, we have done the best we can to avoid extending clone() again
anytime soon (some reserved bytes and clone_args_size field). Would
we still need the flags parameter ? Again its in the new patch
that I pointed to above.

| 
| > An informal poll of reviewers has clone3() with a slight advantage :-)
| >
| >        clone_extended() camp: Serge Hallyn, Kerrisk, Louis Rilling,
| >        clone3(): Sukadev, H. Peter Anvin, Oren, Matt Helsley.
| >
| > I like clone3() but am not insisting on it. I just want a name...
| 
| And I'm not really insisting on a change. As you rightly point out,
| there is much inconsistency in the naming conventions that have been
| used over the years.
| 
| But, because there has been no consistency in the use of numbers, and
| because the number of arguments that are presented in a glibc
| interface may differ from the number of arguments in an underlying
| syscall (several precedents: signalfd4(), pselect(), ppoll()), I'm
| inclined to think that clonex() or clone_ext() is slighly better than
| clone3(). But, certainly, my arguments are not compelling.
