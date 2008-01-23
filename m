Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYAWWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYAWWFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYAWWEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:04:43 -0500
Received: from namei.org ([69.55.235.186]:38975 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753710AbYAWWEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:04:41 -0500
Date: Thu, 24 Jan 2008 09:03:28 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
 settings for task actions [try #2]
In-Reply-To: <22469.1201121532@redhat.com>
Message-ID: <Xine.LNX.4.64.0801240902460.21138@us.intercode.com.au>
References: <1200409128.9669.46.camel@moss-spartans.epoch.ncsc.mil>
 <3466.1200319279@redhat.com> <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil>
 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com>
 <17868.1199897484@redhat.com> <3524.1200319577@redhat.com> 
 <22469.1201121532@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008, David Howells wrote:

> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > Make sure that you or Dan submits a policy patch to register these
> > classes and permissions in the policy when the kernel patch is queued
> > for merge.
> 
> Do I just send the attached patch to <selinux@tycho.nsa.gov>?  

That should be enough (and that list is on the cc).

>Or do I need to
> make a diff from a point in the tree nearer the root?  Is there anything else
> I need to alter whilst I'm at it?
> 
> David
> ---
> Index: policy/flask/security_classes
> ===================================================================
> --- policy/flask/security_classes	(revision 2573)
> +++ policy/flask/security_classes	(working copy)
> @@ -109,4 +109,7 @@
>  # network peer labels
>  class peer
>  
> +# kernel services that need to override task security
> +class kernel_service
> +
>  # FLASK
> Index: policy/flask/access_vectors
> ===================================================================
> --- policy/flask/access_vectors	(revision 2573)
> +++ policy/flask/access_vectors	(working copy)
> @@ -736,3 +736,10 @@
>  {
>  	recv
>  }
> +
> +# kernel services that need to override task security
> +class kernel_service
> +{
> +	use_as_override
> +	create_files_as
> +}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
James Morris
<jmorris@namei.org>
