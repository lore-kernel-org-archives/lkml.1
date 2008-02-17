Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYBQU5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYBQU5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYBQU47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:56:59 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:31936 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYBQU46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:56:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wIbKmj7G8F/6SnC38Jy1d9KOAsGURoyxtoG+hIm4uByatu/YD7YAD3G7vf2+fmqu1dMv0L5tTTsXER28Osc15sIOb1JnpspG5YgCD4BIfiy1gUO59GUX4TfnjjR9+vpSOUWynGmOwhuXo9USZg+6uwtp0t+VlSLPH+5eEGh65j4=
Message-ID: <5d6222a80802171256l6e178eb8h1080bfd5a6b95ef3@mail.gmail.com>
Date: Sun, 17 Feb 2008 18:56:56 -0200
From: "Glauber Costa" <glommer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 4/5] [PATCH] introduce paravirt helpers
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com
In-Reply-To: <20080217180509.GW6006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202757365-18634-1-git-send-email-gcosta@redhat.com>
	 <1202757365-18634-2-git-send-email-gcosta@redhat.com>
	 <1202757365-18634-3-git-send-email-gcosta@redhat.com>
	 <1202757365-18634-4-git-send-email-gcosta@redhat.com>
	 <20080217180509.GW6006@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 4:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Glauber Costa <gcosta@redhat.com> wrote:
>
> >  config X86_VSMP
> >       bool "Support for ScaleMP vSMP"
> >       depends on X86_64 && PCI
> > -      help
> > +     select PARAVIRT
> > +     help
>
> hm, what's the idea here?

guys from scalemp can probably give a better picture if needed,
but in a nutshell, there are two aspects involved with the vsmp
support. The first one
is special L1 alignments, and the second, specialized irq handling routines.

Only the second one is paravirt in itself, and are the ones addressed
in this patch.
The specialized routines now goes through paravirt ops. So when using
a vsmp machine,
paravirt has to be selected, in order to enable such functions.

-- 
Glauber  Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
