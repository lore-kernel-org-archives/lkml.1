Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYCNJRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYCNJRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYCNJQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:16:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29972 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYCNJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:16:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=nKHP1+JqCtuqNYKq+bSVmy77u1UE0JxVF8TnG3w1zjA6brwPTXZA64cYrzUu2FqHQ
	ZyQt4FIGuBv+Plg5xs4TQ==
Message-ID: <6599ad830803140216k1a04ce4ej4779bf10ec6ef4f9@mail.gmail.com>
Date: Fri, 14 Mar 2008 02:16:46 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       "Greg KH" <greg@kroah.com>, "Stephen Smalley" <sds@epoch.ncsc.mil>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <20080313032749.GA13258@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080313032749.GA13258@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 8:27 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
>  While composing this with the ns_cgroup may seem logical, it is not
>  the right thing to do, because updates to /cg/cg1/devcg.deny are
>  not reflected in /cg/cg1/cg2/devcg.allow.

Maybe you should follow up the tree to ensure that all parent groups
have access to the device too? Or alternatively, cache the results of
this lookup whenever permissions for a device change?

>
>  A task may only be moved to another devcgroup if it is moving to
>  a direct descendent of its current devcgroup.

What's the rationale for that?

>
>  CAP_NS_OVERRIDE is defined as the capability needed to cross namespaces.
>  A task needs both CAP_NS_OVERRIDE and CAP_SYS_ADMIN to create a new
>  devcgroup, update a devcgroup's access, or move a task to a new
>  devcgroup.

But this isn't necessarily crossing namespaces. It could be used for
device control in the same namespace (e.g. allowing a job to access a
raw disk for its data storage rather than going through the
filesystem).

Paul
