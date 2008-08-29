Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYH2KsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYH2KsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYH2KsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:48:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:39543 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbYH2KsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:48:12 -0400
Date: Fri, 29 Aug 2008 20:47:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Markku Savela <msa@moth.iki.fi>
cc: Theodore Tso <tytso@mit.edu>, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: Frustrated with capabilities..
In-Reply-To: <200808291018.m7TAIcqJ030105@burp.tkv.asdf.org>
Message-ID: <alpine.LRH.1.10.0808292034550.30593@tundra.namei.org>
References: <87hc96by8x.fsf@burp.tkv.asdf.org> <20080828141826.GA6797@ucw.cz> <200808281445.m7SEjYsB007502@burp.tkv.asdf.org> <20080828174854.GM26987@mit.edu> <200808291018.m7TAIcqJ030105@burp.tkv.asdf.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Markku Savela wrote:

> File capabilities (nor selinux) won't work, because the "helper
> applications" need to be executed with different capabilities and
> permissions, depending on the "manifests" of the downloaded
> "code". Obviously, serious permissions are granted only to properly
> verified "code" (signed).
> 
>   [Any ideas how selinux would help to enforce a permission which is
>   dynamically defined by installing application?]

You could implement a specialized userpsace application launcher, which 
parses the manifest, determines a security context for the application, 
performs any requiste object labeling, then launches the application it in 
that context.  The kernel policy could enforce which particular contexts 
the launcher was authorized to use, and which applications could be 
launched in this way, then confine the launched applications.

> 
> I'm using "code" in quotes, because in my mind, it can include HTML, 
> word documents, spreadsheets, images. Data formats are getting so 
> complex, that they start to look more like interpreted code, than plain 
> passive data.
> 
> File capabilities (and setuid/setgid bits, selinux attributes) have
> another problem: they only work properly on internal disk. No sane
> person would allow them to be effective from removable media or NFS.

There is a project underway to extend SELinux (and MAC labeling in 
general) over NFS: http://selinuxproject.org/page/Labeled_NFS


- James
-- 
James Morris
<jmorris@namei.org>
