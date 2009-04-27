Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZD0J7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZD0J7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbZD0J6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:58:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbZD0J6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:58:16 -0400
Date: Mon, 27 Apr 2009 05:58:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Message-ID: <20090427095815.GA12323@infradead.org>
References: <1240821139-7247-21-git-send-email-monstr@monstr.eu> <1240821139-7247-22-git-send-email-monstr@monstr.eu> <1240821139-7247-23-git-send-email-monstr@monstr.eu> <1240821139-7247-24-git-send-email-monstr@monstr.eu> <1240821139-7247-25-git-send-email-monstr@monstr.eu> <1240821139-7247-26-git-send-email-monstr@monstr.eu> <1240821139-7247-27-git-send-email-monstr@monstr.eu> <1240821139-7247-28-git-send-email-monstr@monstr.eu> <1240821139-7247-29-git-send-email-monstr@monstr.eu> <1240821139-7247-30-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240821139-7247-30-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 10:32:18AM +0200, monstr@monstr.eu wrote:
> +# ifdef __uClinux__
>  struct stat64 {
>  	unsigned long long	st_dev;
>  	unsigned long	__unused1;
> @@ -69,5 +69,29 @@ struct stat64 {
>  
>  	unsigned long	__unused8;
>  };
> +# else /* __uClinux__ */
> +/* FIXME */
> +struct stat64 {
> +	unsigned long long	st_dev; /* Device.*/
> +	unsigned long long	st_ino; /* File serial number.*/
> +	unsigned int		st_mode; /* File mode.*/
> +	unsigned int		st_nlink; /* Link count. */
> +	unsigned int		st_uid; /* User ID of the file's owner. */
> +	unsigned int		st_gid; /* Group ID of the file's group. */
> +	unsigned long long	st_rdev; /* Device number, if device. */
> +	unsigned short		__pad2;
> +	long long		st_size; /* Size of file, in bytes. */
> +	int			st_blksize; /* Optimal block size for I/O. */
> +	long long		st_blocks; /* No. 512-byte blocks allocated */
> +	int			st_atime; /* Time of last access.  */
> +	unsigned int		st_atime_nsec;
> +	int			st_mtime; /* Time of last modification. */
> +	unsigned int		st_mtime_nsec;
> +	int			st_ctime; /* Time of last status change. */
> +	unsigned int		st_ctime_nsec;
> +	unsigned int		__unused4;
> +	unsigned int		__unused5;
> +};
> +# endif /* __uClinux__ */

Userspace ABIs must not change because of MMU vs not.

