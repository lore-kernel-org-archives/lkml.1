Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbXFZCNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbXFZCNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbXFZCNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:13:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:30619 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXFZCNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mCqLT5E7hLwVEjBs2fW++MlNv3Gl8xtFORX49VxREoU2zjV+hd7DPcdr7yTUXMzU9HJ3iq6kobOOXHzJG5zu71P3vqngyCvtQF009PqrF3WIfCLNAIRrluPTO5cjZ00fPY1QqREfZa0HQr/SrSvpUpXqHD1tMt9F2TDLhiAapv0=
Message-ID: <a781481a0706251913x73a5680ej33a0e2ac61bad418@mail.gmail.com>
Date: Tue, 26 Jun 2007 07:43:34 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Alexander Wuerstlein" <snalwuer@cip.informatik.uni-erlangen.de>
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Cc: "Alexander Wuerstlein" <arw@arw.name>, linux-kernel@vger.kernel.org,
       "Johannes Schlumberger" <spjsschl@stud.informatik.uni-erlangen.de>,
       linux-crypto@vger.kernel.org
In-Reply-To: <20070626002659.GM9741@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
	 <1182536729847-git-send-email-arw@arw.name>
	 <a781481a0706221236t3b399afdkf2e07cb109fba226@mail.gmail.com>
	 <20070624225809.GI9741@cip.informatik.uni-erlangen.de>
	 <a781481a0706251653wa2db7e4geb181f3827a10f9d@mail.gmail.com>
	 <20070626002659.GM9741@cip.informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Alexander Wuerstlein
<snalwuer@cip.informatik.uni-erlangen.de> wrote:
> [...]
> Nope. I unluckily wrote 'userspace' where I should have said something else:
> Chain-of-trust is handled in what I would label 'Adminspace' (Where we do the
> signing as in points 1 and 2). There is a very small number of signatures (in
> our example one) known to the kernel and only those are trusted, and those are
> applied to the binaries by the administrator in your point 2. The kernel does
> and should never rely on userspace to tell it which signatures are trustworthy.
> Only the administrator may do so by means of the signatures directly compiled
> into the kernel.
>
> So in short: Chain-of-trust is handled by the administrator in his secure
> central location.

Ok, so the "trust chain" you're talking about is simply the decision of the
admin to compile-in the (verified and trusted) public keys of known trusted
entities into the kernel at build time. That is not really scalable, but I guess
you might just as well impose such a restriction for sake of simplicity.

[ I initially thought a scenario where a given binary is signed by an
entity whose
corresponding public key is _not_ present in the kernel, but who does possess
a signature -- over its name, id and public key -- by another entity whose
corresponding public key _is_ built into the kernel). Then at the time of
verification there's really no other alternative to *build* the entire
chain at the
_point of verification_ (in-kernel) itself ... but this obviously
introduces huge and
ugly complexities that you'd have a hard time bringing into the kernel :-) That
"signature over name, id and public key" could be a _certificate_ (if you care
about following standards), and building their chains in-kernel ... well. But if
you really want to differentiate between kernel and userspace from security
perspective, and want to give such functionality, I don't see any easy
way out. ]

> >> So far for the initial idea. Perhaps it would be useful to have more than
> >> one
> >> key or some more complex scheme for obtaining the keys and checking their
> >> validity.  But as all of this would need to be part of the kernel we
> >> decided to
> >> rather keep it as simple as possible, anything complex is better and more
> >> flexibly done in userspace.
> >
> > Well, if you're trusting (privileged) userspace already, I'm suddenly not so
> > sure as to what new is this patchset bringing to the table in the first place
> > ...
>
> We do not trust any userspace application, see above.
>
> > could you also describe the attack vectors / threats that you had in mind
> > that get blocked with the proposed scheme?
>
> We focus on attacks where an attacker may alter some executable file, for
> example by altering a mounted nfs-share, manipulating disk-content by simply
> pulling a disk, mounting it and writing to it, etc.
>
> This relies on the kernel beeing trustworthy of course, so one would need to
> take special measures to protect the kernel-image from beeing similarly
> altered. One (somewhat not-so-secure method) would be supplying kernel images
> by PXE and forbidding local booting, another measure would be using a TPM
> and an appropriate bootloader to check the kernel for unwanted modifications.

Kernel-userspace differentiation from security perspective is always tricky
(so this is why I pointed you to the discussions whenever such stuff, such
as asymmetric crypto and modsign etc are proposed to be merged). It's
definitely not impossible to compromise a _running_ kernel from privileged
userspace, if it really wanted to do so ...

Satyam
