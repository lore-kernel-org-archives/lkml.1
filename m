Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbZDCKEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbZDCKEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZDCKET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:04:19 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:37660 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbZDCKES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:04:18 -0400
Subject: Re: [PATCH 08/14] NFSv4: Add label recommended attribute and NFSv4
 flags
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, "Matthew N. Dodd" <matthew.dodd@sparta.com>,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
In-Reply-To: <alpine.LRH.2.00.0904031921320.11240@tundra.namei.org>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1227733394-1114-9-git-send-email-dpquigl@tycho.nsa.gov>
	 <alpine.LRH.2.00.0904031921320.11240@tundra.namei.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 03 Apr 2009 05:59:30 -0400
Message-Id: <1238752770.7541.58.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 19:31 +1100, James Morris wrote:
> On Wed, 26 Nov 2008, David P. Quigley wrote:
> 
> > diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
> > index ea03667..144eacf 100644
> > --- a/include/linux/nfs4.h
> > +++ b/include/linux/nfs4.h
> > @@ -21,6 +21,7 @@
> >  #define NFS4_FHSIZE		128
> >  #define NFS4_MAXPATHLEN		PATH_MAX
> >  #define NFS4_MAXNAMLEN		NAME_MAX
> > +#define NFS4_MAXLABELLEN	4096
> 
> I can't recall if this has been discussed before, but why is the label 
> length limited to this value?
> 
> SELinux on-disk labels can be up to 64KB in size (XATTR_SIZE_MAX), and I'd 
> like to ensure that we don't end up with an unnecessary disk vs. network 
> label size incompatibility.
> 
> While it seems unlikely that SELinux (and other forms of MAC) security 
> labels would currently exceed 4K, we don't know how SELinux might be 
> extended in the future, and should avoid limiting label flexibility 
> beyond existing constraints.
> 
> 
> - James

We tried to change this to be dynamically allocated based on what was
coming off of the wire but we ran into a problem that it required us to
do allocations where they really shouldn't be done in the rpc/nfsv4
code. Trond suggested to make this static and that if someone really
needed more than a page for their label that something was horrifically
wrong. I'm tempted to agree with him on this but there are people trying
to send contexts with an MLS component with every other compartment set
which tend to be really large. 

Dave 

