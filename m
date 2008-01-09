Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbYAITUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbYAITUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbYAITUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:20:03 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:38463 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbYAITUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:20:00 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: Daniel J Walsh <dwalsh@redhat.com>, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <1316.1199904980@redhat.com>
References: <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil>
	 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com> <17868.1199897484@redhat.com>
	 <1316.1199904980@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 09 Jan 2008 14:19:18 -0500
Message-Id: <1199906358.9393.324.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 18:56 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > Right, the latter is reasonable.
> > Requires adding the class and permission definition to
> > policy/flask/security_classes and policy/flask/access_vectors and then
> > regenerating the kernel headers from those files, ala:
> >   svn co http://oss.tresys.com/repos/refpolicy/trunk refpolicy
> >   cd refpolicy/policy/flask
> >   vi security_classes access_vectors
> >   <add new class to end>
> >   make
> >   make LINUX_D=/path/to/linux-2.6 tokern
> 
> Does this require rebuilding and updating all the SELinux rpms to know about
> the new class?

Policy ultimately has to be updated in order to start writing allow
rules based on the new class/perm.  libselinux et al doesn't have to
change.

If you have a "SELinux:  policy loaded with handle_unknown=allow"
message in your /var/log/messages, then new classes/perms that are not
yet known to the policy will be allowed by default, so the operation
will be permitted by the kernel.

-- 
Stephen Smalley
National Security Agency

