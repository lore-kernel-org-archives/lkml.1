Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYAPSFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYAPSFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYAPSEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:04:53 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:44239 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYAPSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:04:53 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] ia64 aliasing-test: fix gcc warnings on non-ia64
Date: Wed, 16 Jan 2008 11:05:19 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20080115160510.76d2bfbc.randy.dunlap@oracle.com>
In-Reply-To: <20080115160510.76d2bfbc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161105.19820.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008 05:05:10 pm Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Eliminate all build warnings.  OK, these build warnings are from
> a build on x86_64.  When I build on ia64, I don't see warnings.
> ...
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Thanks, Randy.

> ---
>  Documentation/ia64/aliasing-test.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> --- linux-2.6.24-rc7.orig/Documentation/ia64/aliasing-test.c
> +++ linux-2.6.24-rc7/Documentation/ia64/aliasing-test.c
> @@ -16,6 +16,7 @@
>  #include <fcntl.h>
>  #include <fnmatch.h>
>  #include <string.h>
> +#include <sys/ioctl.h>
>  #include <sys/mman.h>
>  #include <sys/stat.h>
>  #include <unistd.h>
> @@ -65,7 +66,7 @@ int scan_tree(char *path, char *file, of
>  {
>  	struct dirent **namelist;
>  	char *name, *path2;
> -	int i, n, r, rc, result = 0;
> +	int i, n, r, rc = 0, result = 0;
>  	struct stat buf;
>  
>  	n = scandir(path, &namelist, 0, alphasort);
> @@ -113,7 +114,7 @@ skip:
>  		free(namelist[i]);
>  	}
>  	free(namelist);
> -	return rc;
> +	return result;
>  }
>  
>  char buf[1024];
> @@ -149,7 +150,7 @@ int scan_rom(char *path, char *file)
>  {
>  	struct dirent **namelist;
>  	char *name, *path2;
> -	int i, n, r, rc, result = 0;
> +	int i, n, r, rc = 0, result = 0;
>  	struct stat buf;
>  
>  	n = scandir(path, &namelist, 0, alphasort);
> @@ -180,7 +181,7 @@ int scan_rom(char *path, char *file)
>  			 * important thing is that no MCA happened.
>  			 */
>  			if (rc > 0)
> -				fprintf(stderr, "PASS: %s read %ld bytes\n", path2, rc);
> +				fprintf(stderr, "PASS: %s read %d bytes\n", path2, rc);
>  			else {
>  				fprintf(stderr, "PASS: %s not readable\n", path2);
>  				return rc;
> @@ -201,10 +202,10 @@ skip:
>  		free(namelist[i]);
>  	}
>  	free(namelist);
> -	return rc;
> +	return result;
>  }
>  
> -int main()
> +int main(void)
>  {
>  	int rc;
>  
> @@ -256,4 +257,6 @@ int main()
>  	scan_tree("/proc/bus/pci", "??.?", 0xA0000, 0x20000, 0);
>  	scan_tree("/proc/bus/pci", "??.?", 0xC0000, 0x40000, 1);
>  	scan_tree("/proc/bus/pci", "??.?", 0, 1024*1024, 0);
> +
> +	return rc;
>  }
> 


