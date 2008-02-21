Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYBUPRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYBUPRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYBUPRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:17:25 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:24326 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYBUPRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:17:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EZ0WFFBRvgZoi2hfLwKY/t/esWqGOA5yzYWLuhSuz+03A66HBn1bbvv4HAz1TVsw/Vx9bjC7bCjHgDzoQWZiFFccjjUzHDL4FKI6/B4kIjpbV3FS5aQehQp6sxbvwV9dlLezir79tEafvH0iujENp3dmgU/bZnHcrUL/VaBxtEQ=
Message-ID: <4d569c330802210717g48d60229t56dd31f9828bad88@mail.gmail.com>
Date: Thu, 21 Feb 2008 10:17:19 -0500
From: "Kevin Coffman" <kwc@citi.umich.edu>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH 00/37] Permit filesystem local caching
Cc: "Daniel Phillips" <phillips@phunq.net>, Trond.Myklebust@netapp.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, casey@schaufler-ca.com
In-Reply-To: <28196.1203605703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
	 <200802201907.40406.phillips@phunq.net> <28196.1203605703@redhat.com>
X-Google-Sender-Auth: bf3832d065e9c41e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 9:55 AM, David Howells <dhowells@redhat.com> wrote:
> Daniel Phillips <phillips@phunq.net> wrote:
>
>
> > Have you got before/after benchmark results?
>
>  See attached.
>
>  These show a couple of things:
>
>   (1) Dealing with lots of metadata slows things down a lot.  Note the result of
>      looking and reading lots of small files with tar (the last result).  The
>      NFS client has to both consult the NFS server *and* the cache.  Not only
>      that, but any asynchronicity the cache may like to do is rendered
>      ineffective by the fact tar wants to do a read on a file pretty much
>      directly after opening it.
>
>   (2) Getting metadata from the local disk fs is slower than pulling it across
>      an unshared gigabit ethernet from a server that already has it in memory.

Hi David,

Your results remind me of this in case you're interested...

http://www.citi.umich.edu/techreports/reports/citi-tr-92-3.pdf
