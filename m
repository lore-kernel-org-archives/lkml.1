Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbYAaCyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbYAaCyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYAaCyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:54:12 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:58591 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbYAaCyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CXSQbz/rzvUyzEqIZXE7yDAlxzgt+AgwvtiV9eglcY1U18CtI7HR6++mqe/Jz1G4C6DQMZQ2+XnIhWvPtJWIxfF5zKk7ftk0CslMWYPJED07xk4fJR9s9ex/tf5eG8pE9ja2JACMEPV0OMXrnYuSnD01bLn2iF3X6z8P+2A5WKs=
Message-ID: <524f69650801301854p5d095233kfebabcfc41b00be4@mail.gmail.com>
Date: Wed, 30 Jan 2008 20:54:06 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [2.6 patch] remove smbfs
Cc: "David Newall" <davidn@davidnewall.com>, "Adrian Bunk" <bunk@kernel.org>,
       sfrench@samba.org, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801310310220.13320@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080128220835.GF8767@does.not.exist>
	 <Pine.LNX.4.64.0801301923450.13036@fbirervta.pbzchgretzou.qr>
	 <524f69650801301053s370c9a2fpd03bf31616e37d9c@mail.gmail.com>
	 <Pine.LNX.4.64.0801302003560.13036@fbirervta.pbzchgretzou.qr>
	 <47A12C71.4050609@davidnewall.com>
	 <Pine.LNX.4.64.0801310310220.13320@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 8:23 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>
> On Jan 31 2008 12:33, David Newall wrote:
> >Jan Engelhardt wrote:
> >> On Jan 30 2008 12:53, Steve French wrote:
> >>
> >>> I have mounted to Windows98 a few months ago with no problems (other
> >>> than a few restrictions like you can't set the file times via utimes).
> >>> For mounts to Windows98 note that you have to specify the server
> >>> netbios name on the mount (since it is not the same as the DNS name).
> >>> In your example your would need to specify "servernetbiosname=WIN98"
> >>> in the mount options (until mount.cifs autoretries with
> >>> servernetbiosname assumed to be the beginning of the UNC name - note
> >>> that later servers have a dummy netbios name that is used so this
> >>> mount option is only needed for OS/2 and Win9x).
> >>
> >> Ok that works. I had tried "netbiosname" but not "servernetbiosname"
> >> (only fuzzy memories from the last win98 encounter and the suggestion
> >> to use netbiossomething).
> >
> >Apparently CIFS lacks an adequate man page (otherwise Jan would have
> >discovered servernetbiosname for himself.)  That's sufficient reason to
> >keep smbfs, and just to be radical, why not remove cifs until it's
> >properly documented?  Man pages are essential.

The cifs user guide (note that smbfs did not have a user's guide) does
list the required mount options pretty clearly in the section on mount
syntax on page 4.   Excerpt follows:

mounting to older servers (those prior to1997) may require specifying
two additional fields beyond
those which smbfs required:
a) The server's netbios (RFC1001) name AND the server's tcp (or ip )
address. CIFS does not
assume, as smbfs did, that the tcp name and the netbios name of the
server are the same. The netbios name of the server is specified by
passing the mount option "servern=SERVERNAME" and is not assumed to be
necessarily the same as the tcp name of the server (also note that the
netbios name is usually capitalized). Both tcp/ip name and netbios
name have to be specified for mounts for most old lanman servers. For
example:
         mount -t cifs //tcp-name-of-server/sharename



Current versions of "mount.cifs -h" also list all mount options, and
the README information on the syntax is also current and contains
information which needs to be added to the mount.cifs man page.   I
will make this fix for the mount.cifs man page, it lags behind the
mount.cifs help and the README but any additional updates to the man
page text to clarify it would be welcome.

> smbfs does not seem to do NT/XP mounts, so that's kinda problematic
> too, as fun as it sounds :)





-- 
Thanks,

Steve
