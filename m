Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYAGAyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYAGAyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 19:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYAGAyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 19:54:10 -0500
Received: from ozlabs.org ([203.10.76.45]:56385 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbYAGAyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 19:54:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Subject: Re: [PATCH 0/16] lguest: introduce vcpu structure
Date: Mon, 7 Jan 2008 11:53:57 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       rostedt@goodmis.org
References: <11981576363806-git-send-email-gcosta@redhat.com> <200712261054.46261.rusty@rustcorp.com.au> <5d6222a80801060933h7bc0d158h6e3b445c3db43291@mail.gmail.com>
In-Reply-To: <5d6222a80801060933h7bc0d158h6e3b445c3db43291@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071153.57710.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008 04:33:53 Glauber de Oliveira Costa wrote:
> On Dec 25, 2007 9:54 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >     My only question is whether we should go further and vpu-ify routines
> > like lgread and kill_guest, so that we can avoid more "lg" temporary
> > variables...
>
> Essentially, they don't need it, because they only touch
> globally-visible variables (visible to the guest).
> So it's more of an stylish thing. Using the vcpu in the signature can
> have only one harm:
> It needs the caller to also have a pointer to a vcpu, so we may end up
> using it everywhere, like a domino fall.
>
> Alternatively, in such functions that don't currently receive a vcpu
> (nor they need to), we can convention to always pass
> lg->vcpus[0] to lgread, kill_guest, etc. Which one do you prefer?

I'm happy with a domino effect.  I don't want to see lg->vcpus[0] *anywhere* 
though, because it's non-futureproof.

When I looked through these patches it seems to me that we should accept that 
vcpu is now the basic guest unit, and lg exists to serve it.  Otherwise I 
think you can see the bones of the old UP code poking through, and that's 
ugly.

Thanks!
Rusty.
