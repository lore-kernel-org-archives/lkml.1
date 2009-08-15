Return-Path: <linux-kernel-owner+w=401wt.eu-S1751186AbZHOE6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbZHOE6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 00:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZHOE6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 00:58:36 -0400
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:20145 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750764AbZHOE6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 00:58:35 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: lP8pFLcVM1lTBvtVfdJUsWPSb2t5VRIaBUw4lc75u4u_0bzTDjwEjuN_woXxLwPeKeaI1z9SiIEHAM8EdaFSO1oRNSxOAI1PrbUlnZZx.U5NrcdrHkwC1.4vURkLeQY9FQPyR0me9gb.0gEcp6sF4_pfRAcIHd.uaxttdV1t16Qh9ChE7FH8VzBet87YX60I0ajprreGF6pnhxXj7FptiY6Bz1uZuJtQGtBKeYmIHtsg9MBlBGTFh34r5ai3fWrRqluomR_kRG5kuCeBZMggHdC3wVvK8_HlunB0dltM1dXyQfNv_5_XqLvNrfijCyE0MeYN_ZGi2_lBc5sv4ztv5y1aX5xdxe4Jt6ueD48bwIa1xFOTO75Z5n2LP.ltxBY-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A864008.50907@schaufler-ca.com>
Date: Fri, 14 Aug 2009 21:56:40 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Stephen Smalley <sds@tycho.nsa.gov>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>	<4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>	<4A861291.1030404@schaufler-ca.com> <m1tz09j00q.fsf@fess.ebiederm.org>
In-Reply-To: <m1tz09j00q.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Casey Schaufler <casey@schaufler-ca.com> writes:
>
>   
>> Actually, I see that as a justification for the special purpose
>> scheme rather than a real issue. The real attribute data is going
>> to take up the same amount of space regardless of how it gets
>> managed. And Stephen is correct in thinking that is most cases
>> where there are xattrs there will be only one. I don't see that
>> a mechanism more elaborate than a list is going to gain much in
>> real life. On the other hand, if you wanted to take the ball and
>> run with it, I have a window manager to deal with.
>>     
>
> If you look at things from the point of view of a single inode I would
> have to agree that the storage costs are roughly the same however they
> get managed.
>
> My understanding is that in most inodes all get a label from
> a very small set of possible labels.
>   

Actually, my point is that most files that get xattrs get one xattr.
The set of labels will be small for a Smack system or a real world
MLS system. This is not true for SELinux, where the number of labels
in flight at any given time can be .... large.

> If that is true.  It makes sense to store the set of used labels
> separately from the inodes.  Then on the inode just store a pointer
> to the label.
>   

You have been reading the Smack code, haven't you?

> Saying this in lisp parlance we should be able to use atoms instead of
> strings.
>   

Sorry, but you're not old enough to be slinging lisp at me. (smiley)
But yes, that is an apt comparison.

> At which point we have (I believe) an implementation that is as practically
> as efficient as what was originally proposed but as general and as maintainable
> as your version.
>
> What I don't know is if the set of labels applied to a filesystem is actually
> small, despite having a large number of labels applied.
>   

The question is whether you're more concerned with the xattr behavior
or the LSM behavior. This is where the difference shows itself. If you
look at the LSM, there is one value. If you look at xattrs, there may
be many.

I personally think that the Right Thing(tm) is the xattr view. My
experience is the LSM view. I hope that we don't shut off the Right
Thing in preference to the issue of the day. I have been on both sides
on this one.


