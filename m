Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZF3IZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZF3IZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZF3IYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:24:54 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40012 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZF3IYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dKOBDwcxikpnHMM88MpQ+2hTXwI9Nl+4PLgovzgquwPLJnNMt7T9AAlBCw45x4vUk1
         nxYp8xbhOKsRWdi3wKCHUI3RmfILx/icBo2GgJraOuGmYvEFazUDpN/pI36Kiqd80h3h
         1C7Zm8jyjFB8K8UDlQdimJCKQrqtpv0nnqFc8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906300032310.11018@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>
	 <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>
	 <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
	 <alpine.DEB.2.00.0906300032310.11018@chino.kir.corp.google.com>
Date: Tue, 30 Jun 2009 11:24:53 +0300
X-Google-Sender-Auth: ed16fee38982a3d2
Message-ID: <84144f020906300124n24e206b5tc85dd5cc4661bde7@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 30 Jun 2009, Pekka Enberg wrote:
>> > I'd disagree with disabling slub debugging by default for caches where
>> > oo_order(s->min) increases as the result of using it.  This particular
>> > page allocation failure is happening for, presumably, kmalloc-4096, and
>> > the system has 4K pages.  Disabling debugging for that cache (and any of
>> > its aliases) implicitly will lead to errors going undiagnosed as a result.
>>
>> Well, I obviously don't agree here because kmalloc-4096 debugging
>> causes problems in the real world.

On Tue, Jun 30, 2009 at 10:47 AM, David Rientjes<rientjes@google.com> wrote:
> I don't think CONFIG_SLUB_DEBUG_ON is generally the configuration used in
> the real world.

It is, hence the epic bug report that's eaten too many man hours
already! Look, we encourage _testers_ to turn all as much as debugging
options as possible so we catch bugs early. That why the only sane
defaults are the ones that don't cause other problems!

I don't know why you want to argue this. It's simply not an option to
say "stupid user, fix your config" in core code like the slab
allocator. Enabling CONFIG_SLUB_DEBUG_ON is a very reasonable thing to
do when you are a tester looking for bugs.

On Tue, 30 Jun 2009, Pekka Enberg wrote:
>> So we should fix SLUB debugging as outlined by Mel Gorman and
>> Christoph Lameter. I simply haven't had the time to do it. Patches are
>> welcome!

On Tue, Jun 30, 2009 at 10:47 AM, David Rientjes<rientjes@google.com> wrote:
> You're referring to `slub_debug=A'?  I think CONFIG_SLUB_DEBUG_ON should
> continue to enable debugging on all slab caches and in instances where it
> causes page allocation failures such in Larry's case because
> oo_order(s->min) with debugging on is greater than oo_order(s->min) with
> debugging off, you can emit a friendly warning in your recently added
> slab_out_of_memory() about using `slab_debug=-,<cache>'.
>
> We have a disagreement about which is the default behavior, but I would
> opt on the side of adding exemptions to a debug configuration option as
> opposed to requiring additional command line parameters to be fully
> enabled.

Yup, I was referring to slub_debug=A and no, I don't agree with you
that it should be on by default. Only people who know what they're
doing should enable the option and a random tester by definition
doesn't (no offence to Mr. Random Tester).

                                                   Pekka
