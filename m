Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYJLUR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYJLUR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 16:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbYJLURH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 16:17:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43480 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756681AbYJLURF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 16:17:05 -0400
Date: Sun, 12 Oct 2008 16:16:34 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Steve French" <smfrench@gmail.com>
Cc: rjw@sisk.pl,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       netdev@vger.kernel.org, cooldavid@cooldavid.org,
       "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Fwd: [PATCH] Fix CIFS compilation with
 CONFIG_KEYS unset
Message-ID: <20081012161634.5e410c24@tleilax.poochiereds.net>
In-Reply-To: <524f69650810120957t1a81f23lf3fd75fee78e72c3@mail.gmail.com>
References: <200810121315.37203.rjw@sisk.pl>
	<524f69650810120640v41778375wf0a7662e773da26f@mail.gmail.com>
	<20081012095903.33427ee8@tleilax.poochiereds.net>
	<524f69650810120953t2ec8100cpdddc3ddfce0406d9@mail.gmail.com>
	<524f69650810120957t1a81f23lf3fd75fee78e72c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008 11:57:47 -0500
"Steve French" <smfrench@gmail.com> wrote:

> On Sun, Oct 12, 2008 at 11:53 AM, Steve French <smfrench@gmail.com> wrote:
> > On Sun, Oct 12, 2008 at 8:59 AM, Jeff Layton <jlayton@redhat.com> wrote:
> >> On Sun, 12 Oct 2008 08:40:39 -0500
> >> "Steve French" <smfrench@gmail.com> wrote:
> >>
> >> Actually, I like Adrian/Rafael's fix better. I think we should avoid
> >> cluttering up the code with #ifdef's where possible. key_put() already
> >> is a no-op when CONFIG_KEYS is disabled. We might as well do the same
> >> thing with key_revoke().
> > I don't think it matters much - but we probably shouldn't be
> > overriding global functions.
> 
> To clarify, I like fixing it in keys.h better than overriding it in
> cifs, but in the meantime we need an ifdef in cifs until keys.h
> changes.
> 
> 
> 

It's your call, but if we're going to carry a temporary patch, then I'd
prefer to just carry the one that adds the empty key_revoke definition.
I don't think there's much benefit to changing the cifs code for this,
but I don't feel very strongly about it either way...
-- 
Jeff Layton <jlayton@redhat.com>
