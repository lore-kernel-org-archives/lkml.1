Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYAFReK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYAFReK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbYAFRd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:33:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:56535 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbYAFRd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:33:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qYWgwwv+10djWY6ufblvNb8xFhORII4L7WUOPK1AclbbudHXciqcEIKraJyTEtQCCbUeshVnTn+YFyV2Fdo/mfTWbzK2cwaaaa/L+SVHo5MB5/BqBVVdRRd59SJ62MC21i/6oypfVw/AUF+BExU49/UQqUruT2F7r4ZIo16Ae10=
Message-ID: <5d6222a80801060933h7bc0d158h6e3b445c3db43291@mail.gmail.com>
Date: Sun, 6 Jan 2008 15:33:53 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/16] lguest: introduce vcpu structure
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       rostedt@goodmis.org
In-Reply-To: <200712261054.46261.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11981576363806-git-send-email-gcosta@redhat.com>
	 <200712261054.46261.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 25, 2007 9:54 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Friday 21 December 2007 00:33:40 Glauber de Oliveira Costa wrote:
> > this patch makes room for the vcpu structure in lguest, already used in
> > this very same way at lguest64. It's the first part of our plan to
> > have lguest and lguest64 unified too.
>
> Hi Glauber!
>
>     These patches look really solid, thanks!  A few minor things, then I'll
> apply them and push them for 2.6.25.

Thanks for all comments. I was in vacations until today, and I'll
repost a new version that address all your comments
soon (that's why I'm not answering each of them individually now, have
to look carefully)

>     My only question is whether we should go further and vpu-ify routines like
> lgread and kill_guest, so that we can avoid more "lg" temporary variables...
Essentially, they don't need it, because they only touch
globally-visible variables (visible to the guest).
So it's more of an stylish thing. Using the vcpu in the signature can
have only one harm:
It needs the caller to also have a pointer to a vcpu, so we may end up
using it everywhere, like a domino fall.

Alternatively, in such functions that don't currently receive a vcpu
(nor they need to), we can convention to always pass
lg->vcpus[0] to lgread, kill_guest, etc. Which one do you prefer?

> > When two dogs hang out, you don't have new puppies right in the other day.
> > Some time has to be elapsed. They have to grow first. In this same spirit,
> > having these patches _do not_ mean smp guests can be launched (yet)
> > Much more work is to come, but this is the basic infrastructure.
>
> OK, that made me laugh...
\o/
> Thanks!
> Rusty.
>
>



-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
