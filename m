Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYAaC6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYAaC6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYAaC6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:58:46 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:64176 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYAaC6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:58:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C2MGZDoAwvuV2C5sbaJjWg77dkVmFQNFoAp5wSud7o9FLqeq8YVH6ZARDgUCeCoqdWoKaxyu9Tbw8YRVDrwtSWmzv8JSjK1rtgsjah90pzaZLwy2oQtHABR6xtk6xZljgAxRaNZk5kym4eq0EWS7UnrQYgpNC4TPuMvg9PKkeXc=
Message-ID: <524f69650801301858p4f35a0b0r5201492a32efd091@mail.gmail.com>
Date: Wed, 30 Jan 2008 20:58:44 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Steve Langasek" <vorlon@debian.org>
Subject: Re: [2.6 patch] remove smbfs
Cc: "Adrian Bunk" <bunk@kernel.org>, sfrench@samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       "Jeff Layton" <jlayton@redhat.com>
In-Reply-To: <20080131013415.GA3768@dario.dodds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080128220835.GF8767@does.not.exist>
	 <200801302216.13788.linux@kukkukk.com>
	 <20080130174103.17ff8197@tleilax.poochiereds.net>
	 <20080130225810.GU29368@does.not.exist>
	 <20080130193412.61c6e2e9@tleilax.poochiereds.net>
	 <20080131004717.GX29368@does.not.exist>
	 <20080131013415.GA3768@dario.dodds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 7:34 PM, Steve Langasek <vorlon@debian.org> wrote:
> On Thu, Jan 31, 2008 at 02:47:17AM +0200, Adrian Bunk wrote:
> > > smbfs has the unfortunate quality of momentum. A lot of users aren't
> > > aware of CIFS at all since smbfs basically does what they need it to
> > > do. Some extra warning for those users would be nice.
>
> > And many users will start whining loudly that the not deprecated driver
> > (in this case cifs) has this or that bug not before the patch to finally
> > remove the deprecated feature got applied or at least posted.
>
> > And will demand that it therefore does not get removed.
>
> We've had about 3 of these in Debian since deciding to cut it from the
> upcoming release.  (The kicker for us was the samba security update that
> wasn't tested with smbfs as a client.)  The key regressions of interest
> relative to smbfs seem to be:
>
> - lack of DFS support
> - lack of netbios name resolution for UNC share names

> The former seems to be a kernel issue whose resolution is in progress, and I
> think the latter would have to be addressed in the userspace mount tools?

DFS support has never been in any smb client except Windows and the
user space smbclient (but only for about a year) - it has been in
Samba server for a while.   The final piece necessary for DFS support
has not been merged but is expected in the next few weeks - Christoph
and others noticed some problems during the review of the patch series
that I would like to address including rewriting CIFSDFSGetReferral.

lack of automatic netbios name resolution for the server name portion
of the UNC name was discussed in earlier posts - but can be done in
mount.cifs.  More intricate techniques (probing via astat for netbios
name discovery - would require more kernel code)



-- 
Thanks,

Steve
