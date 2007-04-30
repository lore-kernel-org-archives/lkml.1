Return-Path: <linux-kernel-owner+w=401wt.eu-S1946692AbXD3TLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946692AbXD3TLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946647AbXD3TLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:11:42 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:4523 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946687AbXD3TLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bcjyf95MsmPL9XdZtfpSAqJyTJIGUrRwkvga9NaTerFm6/G96MMVKqEV92o2mr0O0UqnrfEqHQ0Ej1X9BUV0vH0REV7f/OgoR500egVelz65Hqw3bZnr4/7lvLLLRomNpaQj60kbQ3ctUNDLZUYunRcJSrR6ExWi4nQe+Zk/1g8=
Message-ID: <524f69650704301211g5e816210s5bb03f4b3231c4b@mail.gmail.com>
Date: Mon, 30 Apr 2007 14:11:35 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Anton Altaparmakov" <aia21@cam.ac.uk>
Subject: Re: UID/GID override on CIFS mounts to Samba and proposed new mount parameter to disable Unix Extensions on the client
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <FF9E865E-BD98-477F-A48D-1E501F516FB2@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650704300726l38c855fds49b00b9bd98360ac@mail.gmail.com>
	 <FF9E865E-BD98-477F-A48D-1E501F516FB2@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The CIFS Unix Extensions are used by multiple clients now (not just
Linux) but originally I thought that it might be confusing to Linux
users  to call the configuration setting for that in /proc/fs/cifs
"Unix" instead of "Linux" (and since it has been there for years and
is externally visible, it is probably not a good idea to change its
name in proc) but for a mount option it might make sense to refer to
them as "unixextensions=no" (similar to Samba server's smb.conf
setting name).  I also though about calling it:

"noposix" or "noposixpaths" ("posix paths" are one of the capabilities
negotiated when Unix Extension are turned on) but that might imply
that the client is turning off compensations that is can use for
mounting to Windows (like JRA's byte range lock emulation, and the
optional SFU-like emulation of device files and symlinks)

On 4/30/07, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
> On 30 Apr 2007, at 15:26, Steve French wrote:
> > When CIFS Unix Extensions are negotiated we get the Unix uid and gid
> > owners of the file from the server (on the Unix Query Path Info
> > levels), but if the server's uids don't match the client uid's users
> > were having to disable the Unix Extensions (which turned off features
> > they still wanted).   The attached patch allows users to override uid
> > and/or gid for file/directory owner with a default uid and/or gid
> > specified at mount (as is often done when mounting from Linux cifs
> > client to Windows server).  The attached patch also displays the uid
> > and gid used by default in /proc/mounts (if applicable).
> >
> > I also would like suggestions on what we should call a proposed mount
> > option (not coded yet) which would disable the CIFS Unix Extensions on
> > a per-mount basis (or more likely actually would require it on the
> > first mount to the server, subsequent mounts would probably inherit
> > the capabilities).  Current cifs code can disable mount options before
> > a mount by specifying
> >
> >     "echo 0 > /proc/fs/cifs/LinuxExtensionsEnabled")
> >
> > but it might be easier to specify it on mount (e.g.
> > "nolinuxextensions" or "linuxextensions=no" ?).    Slightly harder
> > would be disabling Unix Extensions after the user has already mounted
> > (with Unix Extensions) to the same server (perhaps to a different
> > share).  How important would it be to have two mounts to the same
> > server one with unix extensions and one without?
>
> Why "linuxextensions"?  I thought those are the "UNIX extensions"
> that Samba provides no matter on which platform it is run such as
> Linux, Mac OS X, Solaris, etc...
>
> Best regards,
>
>         Anton


-- 
Thanks,

Steve
