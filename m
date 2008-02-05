Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYBELb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYBELb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYBELbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:31:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYBELbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:31:50 -0500
Date: Tue, 5 Feb 2008 06:31:14 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Guenter Kukkukk <linux@kukkukk.com>, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       sfrench@samba.org
Subject: Re: [2.6 patch] remove smbfs
Message-ID: <20080205063114.7d7fc684@tleilax.poochiereds.net>
In-Reply-To: <20080205001805.0ea014f3.akpm@linux-foundation.org>
References: <20080128220835.GF8767@does.not.exist>
	<200801302216.13788.linux@kukkukk.com>
	<20080130174103.17ff8197@tleilax.poochiereds.net>
	<20080205001805.0ea014f3.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 00:18:05 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 30 Jan 2008 17:41:03 -0500 Jeff Layton <jlayton@redhat.com> wrote:
> 
> > I have no problem with targeting smbfs for removal, but I thought
> > Andrew had an unofficial policy that we should first mark things to be
> > deprecated, and then remove them 2 releases later. That seems like a
> > sensible policy to me. If we mark it deprecated in 2.6.25 then we can
> > remove it after 2.6.26 is released.
> > 
> > It might not even hurt to have a nice loud printk when the smbfs
> > module is plugged in to warn users that it's slated to be removed,
> > and that they should move to CIFS as soon as possible.
> 
> I've patiently had this:
> 
> 
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> smbfs is a bit buggy and has no maintainer.  Change it to shout at the user on
> the first five mount attempts - tell them to switch to CIFS.
> 
> Come December we'll mark it BROKEN and see what happens.
> 
> [olecom@flower.upol.cz: documentation update]
> Cc: Urban Widmark <urban@teststation.com>
> Acked-by: Steven French <sfrench@us.ibm.com>
> Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
> Cc: <jlayton@redhat.com.
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/Kconfig       |   28 ++++++++++++++--------------
>  fs/smbfs/inode.c |    7 +++++++
>  2 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff -puN fs/Kconfig~deprecate-smbfs-in-favour-of-cifs fs/Kconfig
> --- a/fs/Kconfig~deprecate-smbfs-in-favour-of-cifs
> +++ a/fs/Kconfig
> @@ -1181,7 +1181,7 @@ config BEFS_DEBUG
>  	depends on BEFS_FS
>  	help
>  	  If you say Y here, you can use the 'debug' mount option to enable
> -	  debugging output from the driver. 
> +	  debugging output from the driver.
>  
>  config BFS_FS
>  	tristate "BFS file system support (EXPERIMENTAL)"
> @@ -1292,7 +1292,7 @@ config JFFS2_FS_XATTR
>  	  Extended attributes are name:value pairs associated with inodes by
>  	  the kernel or by users (see the attr(5) manual page, or visit
>  	  <http://acl.bestbits.at/> for details).
> -	  
> +
>  	  If unsure, say N.
>  
>  config JFFS2_FS_POSIX_ACL
> @@ -1303,10 +1303,10 @@ config JFFS2_FS_POSIX_ACL
>  	help
>  	  Posix Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
> -	  
> +
>  	  To learn more about Access Control Lists, visit the Posix ACLs for
>  	  Linux website <http://acl.bestbits.at/>.
> -	  
> +
>  	  If you don't know what Access Control Lists are, say N
>  
>  config JFFS2_FS_SECURITY
> @@ -1318,7 +1318,7 @@ config JFFS2_FS_SECURITY
>  	  implemented by security modules like SELinux.  This option
>  	  enables an extended attribute handler for file security
>  	  labels in the jffs2 filesystem.
> -	  
> +
>  	  If you are not using a security module that requires using
>  	  extended attributes for file security labels, say N.
>  
> @@ -1862,7 +1862,7 @@ config RPCSEC_GSS_SPKM3
>  	  If unsure, say N.
>  
>  config SMB_FS
> -	tristate "SMB file system support (to mount Windows shares etc.)"
> +	tristate "SMB file system support (OBSOLETE, please use CIFS)"
>  	depends on INET
>  	select NLS
>  	help
> @@ -1885,8 +1885,8 @@ config SMB_FS
>  	  General information about how to connect Linux, Windows machines and
>  	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.
>  
> -	  To compile the SMB support as a module, choose M here: the module will
> -	  be called smbfs.  Most people say N, however.
> +	  To compile the SMB support as a module, choose M here:
> +	  the module will be called smbfs.  Most people say N, however.
>  
>  config SMB_NLS_DEFAULT
>  	bool "Use a default NLS"
> @@ -1918,7 +1918,7 @@ config SMB_NLS_REMOTE
>  	  smbmount from samba 2.2.0 or later supports this.
>  
>  config CIFS
> -	tristate "CIFS support (advanced network filesystem for Samba, Window and other CIFS compliant servers)"
> +	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
>  	depends on INET
>  	select NLS
>  	help
> @@ -1976,16 +1976,16 @@ config CIFS_WEAK_PW_HASH
>  	  LANMAN based servers such as OS/2 and Windows 95, but such
>  	  mounts may be less secure than mounts using NTLM or more recent
>  	  security mechanisms if you are on a public network.  Unless you
> -	  have a need to access old SMB servers (and are on a private 
> +	  have a need to access old SMB servers (and are on a private
>  	  network) you probably want to say N.  Even if this support
>  	  is enabled in the kernel build, LANMAN authentication will not be
>  	  used automatically. At runtime LANMAN mounts are disabled but
>  	  can be set to required (or optional) either in
>  	  /proc/fs/cifs (see fs/cifs/README for more detail) or via an
> -	  option on the mount command. This support is disabled by 
> +	  option on the mount command. This support is disabled by
>  	  default in order to reduce the possibility of a downgrade
>  	  attack.
> - 
> +
>  	  If unsure, say N.
>  
>  config CIFS_XATTR
> @@ -2026,7 +2026,7 @@ config CIFS_DEBUG2
>  	   messages in some error paths, slowing performance. This
>  	   option can be turned off unless you are debugging
>  	   cifs problems.  If unsure, say N.
> -	   
> +
>  config CIFS_EXPERIMENTAL
>  	  bool "CIFS Experimental Features (EXPERIMENTAL)"
>  	  depends on CIFS && EXPERIMENTAL
> @@ -2117,7 +2117,7 @@ config CODA_FS_OLD_API
>  	  However this new API is not backward compatible with older
>  	  clients. If you really need to run the old Coda userspace
>  	  cache manager then say Y.
> -	  
> +
>  	  For most cases you probably want to say N.
>  
>  config AFS_FS
> diff -puN fs/smbfs/inode.c~deprecate-smbfs-in-favour-of-cifs fs/smbfs/inode.c
> --- a/fs/smbfs/inode.c~deprecate-smbfs-in-favour-of-cifs
> +++ a/fs/smbfs/inode.c
> @@ -500,6 +500,13 @@ static int smb_fill_super(struct super_b
>  	struct smb_fattr root;
>  	int ver;
>  	void *mem;
> +	static int warn_count;
> +
> +	if (warn_count < 5) {
> +		warn_count++;
> +		printk(KERN_EMERG "smbfs is deprecated and will be removed in"
> +				" December, 2006.  Please migrate to cifs\n");
> +	}
>  
>  	if (!raw_data)
>  		goto out_no_data;
> _
> 
> 
> queued for over 1.5 years waiting for the go-ahead from Steve.
> 
> It looks like it's time?  If so, what should I set the date to?

Looks good to me. I'd suggest that we change the printk's to refer to a
release version and state that it will be removed in for 2.6.26 (or
2.6.27 if that's not enough notice). Then, once the previous version is
released, remove it from the tree as soon as possible.

-- 
Jeff Layton <jlayton@redhat.com>
