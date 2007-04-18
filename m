Return-Path: <linux-kernel-owner+w=401wt.eu-S2992748AbXDRVOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992748AbXDRVOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992747AbXDRVOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:14:36 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:60238 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992726AbXDRVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:14:34 -0400
Date: Wed, 18 Apr 2007 17:14:30 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Crispin Cowan <crispin@novell.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <4626746A.9010701@novell.com>
Message-ID: <Line.LNX.4.64.0704181620130.27545@d.namei>
References: <20070417181016.GA10903@one.firstfloor.org>
 <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org>
 <20070417225815.000b0fdb@the-village.bc.nu> <Line.LNX.4.64.0704180935100.25495@d.namei>
 <4626746A.9010701@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Crispin Cowan wrote:

> James Morris wrote:
> > On Tue, 17 Apr 2007, Alan Cox wrote:
> >   
> >> I'm not sure if AppArmor can be made good security for the general case,
> >> but it is a model that works in the limited http environment
> >> (eg .htaccess) and is something people can play with and hack on and may
> >> be possible to configure to be very secure.
> >>     
> > Perhaps -- until your httpd is compromised via a buffer overflow or 
> > simply misbehaves due to a software or configuration flaw, then the 
> > assumptions being made about its use of pathnames and their security 
> > properties are out the window.
> >   
> How is it that you think a buffer overflow in httpd could allow an
> attacker to break out of an AppArmor profile?

Because you can change the behavior of the application and then bypass 
policy entirely by utilizing any mechanism other than direct filesystem 
access: IPC, shared memory, Unix domain sockets, local IP networking, 
remote networking etc.

This not even considering object aliasing (which would allow you to 
inappropriately access objects with full blessing of policy), as I'm 
assuming that the limited environment Alan is referring to entirely 
prevents them.

Also worth noting here is that you have to consider any limited 
environment as enforcing security policy, and thus its configuration 
becomes an additional component of security policy.

So, your real security policy is actually more complicated than it appears 
to be, is not represented completely in the policy configuration file, and 
must be managed disparately.  And it's still only capable of controlling 
access to filesystem objects.



- James
-- 
James Morris
<jmorris@namei.org>
