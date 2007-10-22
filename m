Return-Path: <linux-kernel-owner+w=401wt.eu-S1751207AbXJVUss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbXJVUss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXJVUsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:48:39 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:18594 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbXJVUsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JBzVh9rSSw6H71OX4TK4F9nf2Ybm3/YkH73CCcKtbK8n+HtORpc3Jc55ncV1OpdbRjxxOQKFVVTfwpk3v8BWdmJeq9Zb5E8k+iQ2349DkNfNUVsvJAzkmOij6enMe+rs2Wg+nYIQpLLkXrReebT8FM4ahVqoF3Uh0apckX0j4Tk=
Message-ID: <84144f020710221348x297795c0qda61046ec69a7178@mail.gmail.com>
Date: Mon, 22 Oct 2007 23:48:37 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Erez Zadok" <ezk@cs.sunysb.edu>, "Ryan Finnie" <ryan@finnie.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       cjwatson@ubuntu.com, linux-mm@kvack.org, neilb@suse.de
In-Reply-To: <Pine.LNX.4.64.0710222101420.23513@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI>
	 <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
	 <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
	 <Pine.LNX.4.64.0710222101420.23513@blonde.wat.veritas.com>
X-Google-Sender-Auth: 6efe49e322c0f98c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Mon, 15 Oct 2007, Pekka Enberg wrote:
> > I wonder whether _not setting_ BDI_CAP_NO_WRITEBACK implies that
> > ->writepage() will never return AOP_WRITEPAGE_ACTIVATE for
> > !wbc->for_reclaim case which would explain why we haven't hit this bug
> > before. Hugh, Andrew?

On 10/22/07, Hugh Dickins <hugh@veritas.com> wrote:
> Only ramdisk and shmem have been returning AOP_WRITEPAGE_ACTIVATE.
> Both of those set BDI_CAP_NO_WRITEBACK.  ramdisk never returned it
> if !wbc->for_reclaim.  I contend that shmem shouldn't either: it's
> a special code to get the LRU rotation right, not useful elsewhere.
> Though Documentation/filesystems/vfs.txt does imply wider use.
>
> I think this is where people use the phrase "go figure" ;)

Heh. As far as I can tell, the implication of "wider use" was added by
Neil in commit "341546f5ad6fce584531f744853a5807a140f2a9 Update some
VFS documentation", so perhaps he might know? Neil?

                               Pekka
