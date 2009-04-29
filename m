Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZD2NAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZD2NAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZD2NAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:00:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36537 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbZD2NAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:00:33 -0400
Date: Wed, 29 Apr 2009 14:56:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Eric Paris <eparis@parisplace.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090429125606.GA27901@redhat.com>
References: <20090428223025.GA11997@redhat.com> <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org> <20090429065809.GA477@redhat.com> <1241007630.18249.141.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241007630.18249.141.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Stephen Smalley wrote:
>
> On Wed, 2009-04-29 at 08:58 +0200, Oleg Nesterov wrote:
> >
> > Why do we need to s/IGN/DFL/ and why do we clear ->blocked ? How this can
> > help from the security pov?
>
> We don't want the caller to be able to arrange conditions that prevent
> correct handling of signals (e.g. SIGHUP) by the callee.  That was
> motivated by a specific attack against newrole, but was a general issue
> for any program that runs in a more trusted domain than its caller.

Still can't understand...

If the new image runs in a more trusted domain, then we should not change
SIG_IGN to SIG_DFL ?

For example, a user does "nohup setuid_app". Now, why should we change
SIG_IGN to SIG_DFL for SIGHUP? This makes setuid_app more "vulnerable"
to SIGHUP, not more "protected". Confused.

OK. Since I don't understand the security magic, you can just ignore me.
But I will appreciate any explanation for dummies ;)

> As I recall, I based the logic in part on existing logic in
> call_usermodehelper().

____call_usermodehelper() does this because we should not exec a user-space
application with SIGKILL/SIGSTOP ignored/blocked. We don't have this problem
when user-space execs.

Oleg.

