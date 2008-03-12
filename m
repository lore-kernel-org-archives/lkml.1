Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbYCLQXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbYCLQXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYCLQXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:23:38 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:46954 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYCLQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:23:37 -0400
Message-ID: <47D80381.3030001@hp.com>
Date: Wed, 12 Mar 2008 12:23:29 -0400
From: Linda Knippers <linda.knippers@hp.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: casey@schaufler-ca.com, "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Audit-ML <linux-audit@redhat.com>, Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC][PATCH -v2] Smack: Integrate with Audit
References: <746579.84816.qm@web36612.mail.mud.yahoo.com> <1205336897.23866.296.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1205336897.23866.296.camel@moss-spartans.epoch.ncsc.mil>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
> On Wed, 2008-03-12 at 08:40 -0700, Casey Schaufler wrote:
>> --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>
>>> On Wed, 2008-03-12 at 04:44 +0200, Ahmed S. Darwish wrote:
>>>> Hi!,
>>>>
>>>> Setup the new Audit hooks for Smack. The AUDIT_SUBJ_USER and 
>>>> AUDIT_OBJ_USER SELinux flags are recycled to avoid `auditd' 
>>>> userspace modifications. Smack only needs auditing on 
>>>> a subject/object bases, so those flags were enough.
>>> Only question I have is whether audit folks are ok with reuse of the
>>> flags in this manner, and whether the _USER flag is best suited for this
>>> purpose if you are going to reuse an existing flag (since Smack label
>>> seems more like a SELinux type than a SELinux user).
>> To-mate-o toe-maht-o.
>>
>> There really doesn't seem to be any real reason to create a new
>> flag just because the granularity is different. The choice between
>> _USER and _TYPE (and _ROLE for that matter) is arbitrary from a
>> functional point of view. I say that since Smack has users, but
>> not types or roles, _USER makes the most sense.
> 
> Perhaps I misunderstand, but Smack labels don't represent users (i.e.
> user identity) in any way, so it seemed like a mismatch to use the _USER
> flag there.  Whereas types in SELinux bear some similarity to Smack
> labels - simple unstructured names whose meaning is only defined by the
> policy rules.
> 
> Regardless, it seems like the audit maintainers ought to weigh in on the
> matter.

I don't count as an audit maintainer but I think as long as the
man page is updated to say something other than:

subj_user
    Program's SE Linux User

then its fine for multiple LSMs to use the same rule flags and its
better than inventing new ones for each LSM.  I don't have an opinion
on which flag that's currently specific to SELinux should be recycled
but I think the manpage could be made more generic for all of them.

>>> Certainly will confuse matters if a user has audit filters on SELinux
>>> users in their /etc/audit/audit.rules and then boots a kernel with Smack
>>> enabled.
>> Somehow I doubt that will be their biggest concern.

I agree.

-- ljk
> 

