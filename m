Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZHOCPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZHOCPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 22:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbZHOCPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 22:15:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54691 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbZHOCPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 22:15:07 -0400
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Stephen Smalley <sds@tycho.nsa.gov>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
	<4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>
	<4A861291.1030404@schaufler-ca.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 14 Aug 2009 19:15:01 -0700
In-Reply-To: <4A861291.1030404@schaufler-ca.com> (Casey Schaufler's message of "Fri\, 14 Aug 2009 18\:42\:41 -0700")
Message-ID: <m1tz09j00q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: casey@schaufler-ca.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, sds@tycho.nsa.gov, jmorris@namei.org, dpquigl@tycho.nsa.gov
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Casey Schaufler <casey@schaufler-ca.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs files, directories, and symlinks.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> Actually, I see that as a justification for the special purpose
> scheme rather than a real issue. The real attribute data is going
> to take up the same amount of space regardless of how it gets
> managed. And Stephen is correct in thinking that is most cases
> where there are xattrs there will be only one. I don't see that
> a mechanism more elaborate than a list is going to gain much in
> real life. On the other hand, if you wanted to take the ball and
> run with it, I have a window manager to deal with.

If you look at things from the point of view of a single inode I would
have to agree that the storage costs are roughly the same however they
get managed.

My understanding is that in most inodes all get a label from
a very small set of possible labels.

If that is true.  It makes sense to store the set of used labels
separately from the inodes.  Then on the inode just store a pointer
to the label.

Saying this in lisp parlance we should be able to use atoms instead of
strings.

At which point we have (I believe) an implementation that is as practically
as efficient as what was originally proposed but as general and as maintainable
as your version.

What I don't know is if the set of labels applied to a filesystem is actually
small, despite having a large number of labels applied.

Eric
