Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbZAMIJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbZAMIJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZAMIJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:09:40 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:59432 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZAMIJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:09:39 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 03:09:39 EST
Message-ID: <496C4A56.1040304@kernel.org>
Date: Tue, 13 Jan 2009 00:01:26 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, sam@ravnborg.org, harvey.harrison@gmail.com,
       gorcunov@gmail.com, astor@guardian.no,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] capability.h: extern's make no sense in userspace
References: <1231827545.3212.12.camel@jaswinder.satnam>
In-Reply-To: <1231827545.3212.12.camel@jaswinder.satnam>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

Jaswinder Singh Rajput wrote:
> Impact: fix 2 make headers_check warnings:
> 
>  usr/include/linux/capability.h:72: leaks CONFIG_SECURITY to userspace where it is not valid
>  usr/include/linux/capability.h:73: extern's make no sense in userspace
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/linux/capability.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 02bdb76..1b98725 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -69,10 +69,6 @@ typedef struct __user_cap_data_struct {
>  #define VFS_CAP_U32             VFS_CAP_U32_2
>  #define VFS_CAP_REVISION	VFS_CAP_REVISION_2
>  
> -#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> -extern int file_caps_enabled;
> -#endif
> -
>  struct vfs_cap_data {
>  	__le32 magic_etc;            /* Little endian */
>  	struct {
> @@ -96,6 +92,10 @@ struct vfs_cap_data {
>  #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
>  #define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
>  
> +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> +extern int file_caps_enabled;
> +#endif
> +
>  typedef struct kernel_cap_struct {
>  	__u32 cap[_KERNEL_CAPABILITY_U32S];
>  } kernel_cap_t;
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJbEpT+bHCR3gb8jsRAnafAJ9CohxNIoKkQN5k+VEzFGGtIjdOsACcDQ3e
B/8spQ/5sSkyGQIN1kK0N9g=
=nkwT
-----END PGP SIGNATURE-----
